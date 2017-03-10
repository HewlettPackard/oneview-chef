# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../../resource_provider'

module OneviewCookbook
  module API200
    # LogicalInterconnect API200 provider
    class LogicalInterconnectProvider < ResourceProvider
      def interconnect_handler(present_block, absent_block)
        raise "Unspecified property: 'bay_number'. Please set it before attempting this action." unless @context.bay_number
        raise "Unspecified property: 'enclosure'. Please set it before attempting this action." unless @context.enclosure
        interconnect_list = resource_named(:Interconnect).get_all(@item.client)
        enclosure_item = load_resource(:Enclosure, @context.enclosure)
        # Procedure to get (bay, enclosure) pairs and interconnect state
        listed_pairs = {}
        interconnect_list.each do |inter|
          bayn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Bay' }.first['value']
          encn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Enclosure' }.first['value']
          listed_pairs[[bayn, encn]] = inter['state']
        end
        # Desired (bay, enclosure) interconnect location
        pair = [@context.bay_number.to_s, enclosure_item['uri']]
        # If an interconnect exists in the location, and its state is not 'Absent', so it is present
        if listed_pairs.keys.include?(pair) && listed_pairs[pair] != 'Absent'
          present_block.call(@context.bay_number, enclosure_item)
        else
          absent_block.call(@context.bay_number, enclosure_item)
        end
      end

      # Recursive helper method to set hash values
      def recursive_set(actual, updates)
        updates.each_pair do |k, v|
          if v.respond_to?(:each_pair)
            recursive_set(actual[k], v)
          else
            actual[k] = v
          end
        end
      end

      # Handle the most types of updates
      def update_handler(action, key = nil)
        temp = key ? { key.to_s => Marshal.load(Marshal.dump(@item[key])) } : Marshal.load(Marshal.dump(@item.data))
        raise "Resource not found: Action '#{action}' cannot be performed since #{@resource_name} '#{@name}' was not found." unless @item.retrieve!
        return Chef::Log.info("#{@resource_name} '#{@name}' is up to date") if @item.like?(temp)
        Chef::Log.info "#{action.to_s.capitalize.tr('_', ' ')} #{@resource_name} '#{@name}'"
        Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
        Chef::Log.debug "Current state: #{JSON.pretty_generate(@item.data)}"
        Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
        diff = get_diff(@item, temp)
        recursive_set(@item.data, temp)
        @context.converge_by "#{action.to_s.capitalize.tr('_', ' ')} #{@resource_name} '#{@name}'#{diff}" do
          @item.send(action)
        end
      end

      def firmware_handler(action)
        @item.retrieve!
        current_firmware = @item.get_firmware
        @context.firmware_data['command'] = action
        dif_values = @context.firmware_data.select { |k, v| current_firmware[k] != v }
        fw_defined = @context.firmware || @context.firmware_data['sppName']
        raise "Unspecified property: 'firmware'. Please set it before attempting this action." unless fw_defined
        return Chef::Log.info("Firmware #{@context.firmware} from logical interconnect '#{@name}' is up to date") if dif_values.empty?
        fd = load_resource(:FirmwareDriver, @context.firmware)
        raise "Resource not found: Firmware action '#{action}' cannot be performed since the firmware '#{@context.firmware}' was not found." unless fd
        diff = get_diff(current_firmware, @context.firmware_data)
        Chef::Log.info "#{action.to_s.capitalize.tr('_', ' ')} #{@resource_name} '#{@name}'"
        Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource firmware options differs from OneView resource."
        Chef::Log.debug "Current state: #{JSON.pretty_generate(current_firmware)}"
        Chef::Log.debug "Desired state: #{JSON.pretty_generate(@context.firmware_data)}"
        @context.converge_by "#{action.capitalize} firmware '#{@context.firmware}' from logical interconnect '#{@name}'#{diff}" do
          @item.firmware_update(action, fd, @context.firmware_data)
        end
      end

      def add_interconnect
        noaction = proc do
          Chef::Log.info("Interconnect already created in #{@context.enclosure} at bay #{@context.bay_number}")
        end
        do_add = proc do |bay, enc|
          @context.converge_by "Add interconnect in #{@context.enclosure} at bay #{@context.bay_number}" do
            @item.create(bay, enc)
          end
        end
        interconnect_handler(noaction, do_add)
      end

      def remove_interconnect
        do_remove = proc do |bay, enc|
          @context.converge_by "Remove interconnect in #{@context.enclosure} at bay #{@context.bay_number}" do
            @item.delete(bay, enc)
          end
        end
        noaction = proc do
          Chef::Log.info("Interconnect not present in #{@context.enclosure} at bay #{@context.bay_number}")
        end
        interconnect_handler(do_remove, noaction)
      end

      def update_internal_networks
        @item.retrieve!
        @context.internal_networks.collect! { |n| load_resource(:EthernetNetwork, n) }
        if @item['internalNetworkUris'].sort == @context.internal_networks.collect { |x| x['uri'] }.sort
          Chef::Log.info("Internal networks for #{@resource_name} #{@name} are up to date")
        else
          diff = get_diff(@item, 'internalNetworkUris' => @context.internal_networks)
          @context.converge_by("Update internal networks for #{@resource_name} '#{@name}'#{diff}") do
            @item.update_internal_networks(*@context.internal_networks)
          end
        end
      end

      def update_settings
        update_handler(:update_settings)
      end

      def update_ethernet_settings
        update_handler(:update_ethernet_settings, 'ethernetSettings')
      end

      def update_port_monitor
        update_handler(:update_port_monitor, 'portMonitor')
      end

      def update_qos_configuration
        update_handler(:update_qos_configuration, 'qosConfiguration')
      end

      def update_telemetry_configuration
        update_handler(:update_telemetry_configuration, 'telemetryConfiguration')
      end

      def update_snmp_configuration
        traps = convert_keys(@context.trap_destinations, :to_s)
        unless @item['snmpConfiguration']['trapDestinations']
          @item['snmpConfiguration']['trapDestinations'] = []
        end
        traps.each_pair do |k, v|
          trap_opts = @item.generate_trap_options(v['enetTraps'], v['fcTraps'], v['vcmTraps'], v['severities'])
          @item.add_snmp_trap_destination(k, v['trapFormat'], v['communityString'], trap_opts)
        end
        update_handler(:update_snmp_configuration, 'snmpConfiguration')
      end

      def update_firmware
        firmware_handler('Update')
      end

      def stage_firmware
        firmware_handler('Stage')
      end

      def activate_firmware
        firmware_handler('Activate')
      end

      def update_from_group
        @item.retrieve!
        # Nothing to verify
        @context.converge_by "Update #{@resource_name} '#{@name}' from group" do
          @item.compliance
        end
      end

      def reapply_configuration
        @item.retrieve!
        # Nothing to verify
        @context.converge_by "Reapply configuration in #{@resource_name} '#{@name}'" do
          @item.configuration
        end
      end
    end
  end
end
