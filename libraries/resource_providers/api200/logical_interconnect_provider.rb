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

module OneviewCookbook
  module API200
    # LogicalInterconnect API200 provider
    class LogicalInterconnectProvider < ResourceProvider
      def interconnect_handler(present_block, absent_block)
        raise "Unspecified property: 'bay_number'. Please set it before attempting this action." unless @new_resource.bay_number
        raise "Unspecified property: 'enclosure'. Please set it before attempting this action." unless @new_resource.enclosure
        interconnect_list = resource_named(:Interconnect).get_all(@item.client)
        enclosure_item = load_resource(:Enclosure, @new_resource.enclosure)
        # Procedure to get (bay, enclosure) pairs and interconnect state
        listed_pairs = {}
        interconnect_list.each do |inter|
          bayn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Bay' }.first['value']
          encn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Enclosure' }.first['value']
          listed_pairs[[bayn, encn]] = inter['state']
        end
        # Desired (bay, enclosure) interconnect location
        pair = [@new_resource.bay_number.to_s, enclosure_item['uri']]
        # If an interconnect exists in the location, and its state is not 'Absent', so it is present
        if listed_pairs.keys.include?(pair) && listed_pairs[pair] != 'Absent'
          present_block.call(@new_resource.bay_number, enclosure_item)
        else
          absent_block.call(@new_resource.bay_number, enclosure_item)
        end
      end

      # Recursive helper method to set hash values
      def recursive_set(actual, updates)
        updates.each_pair do |k, v|
          if v.respond_to?(:each_pair) && actual[k].respond_to?(:each_pair)
            recursive_set(actual[k], v)
          else
            actual[k] = v
          end
        end
      end

      # Handle the most types of updates
      def update_handler(action, key = nil)
        temp = key ? { key.to_s => Marshal.load(Marshal.dump(@item[key])) } : Marshal.load(Marshal.dump(@item.data))
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        return Chef::Log.info("#{@resource_name} '#{@name}' is up to date") if @item.like?(temp)
        diff = get_diff(@item, temp)
        Chef::Log.info "#{action.to_s.capitalize.tr('_', ' ')} #{@resource_name} '#{@name}'#{diff}"
        Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
        Chef::Log.debug "Current state: #{JSON.pretty_generate(@item.data)}"
        Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
        recursive_set(@item.data, temp)
        @context.converge_by "#{action.to_s.capitalize.tr('_', ' ')} #{@resource_name} '#{@name}'" do
          @item.send(action)
        end
      end

      def firmware_handler(action)
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        current_firmware = @item.get_firmware
        @new_resource.firmware_data['command'] = action
        dif_values = @new_resource.firmware_data.reject { |k, v| current_firmware[k] == v }
        fw_defined = @new_resource.firmware || @new_resource.firmware_data['sppName']
        raise "Unspecified property: 'firmware'. Please set it before attempting this action." unless fw_defined
        return Chef::Log.info("Firmware #{@new_resource.firmware} from logical interconnect '#{@name}' is up to date") if dif_values.empty?
        fd = load_resource(:FirmwareDriver, @new_resource.firmware)
        raise "Resource not found: Action '#{action}' cannot be performed since the firmware '#{@new_resource.firmware}' was not found." unless fd
        diff = get_diff(current_firmware, @new_resource.firmware_data)
        Chef::Log.info "#{action.to_s.capitalize.tr('_', ' ')} #{@resource_name} '#{@name}'#{diff}"
        Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource firmware options differs from OneView resource."
        Chef::Log.debug "Current state: #{JSON.pretty_generate(current_firmware)}"
        Chef::Log.debug "Desired state: #{JSON.pretty_generate(@new_resource.firmware_data)}"
        @context.converge_by "#{action.capitalize} firmware '#{@new_resource.firmware}' from logical interconnect '#{@name}'" do
          @item.firmware_update(action, fd, @new_resource.firmware_data)
        end
      end

      def set_analyzer_port(param_name, data)
        param_value = 'portUri' if param_name == 'uri'
        param_value ||= param_name
        port = @item.get_unassigned_uplink_ports_for_port_monitor.find { |k| k[param_name.to_s] == data[param_value.to_s] }
        raise("Port with name or uri '#{data[param_value.to_s]}' was not found or is already being monitored!") unless port
        data['portUri'] = port['uri']
        data.delete('portName')
        port
      end

      def load_ports(item_to_update)
        port_monitor_attributes = convert_keys(@new_resource.port_monitor, :to_s)
        enable_port_monitor = item_to_update['portMonitor']['enablePortMonitor'] if item_to_update['portMonitor']
        enable_port_monitor ||= port_monitor_attributes['enablePortMonitor']
        if enable_port_monitor
          port = nil
          port = set_analyzer_port('uri', item_to_update['portMonitor']['analyzerPort']) if item_to_update['portMonitor'] && item_to_update['portMonitor']['analyzerPort']
          port ||= set_analyzer_port('portName', port_monitor_attributes['analyzerPort'])
          load_downlink_ports(port_monitor_attributes['monitoredPorts'], port['interconnectName']) unless item_to_update['portMonitor'] && item_to_update['portMonitor']['monitoredPorts']
        end
        temp = item_to_update['portMonitor'] || {}
        item_to_update['portMonitor'] = temp.merge(port_monitor_attributes)
      end

      def load_downlink_ports(monitored_ports, interconnect_name)
        interconnect = load_resource(:Interconnect, interconnect_name)
        monitored_ports.each do |downlink|
          interconnect['ports'].each do |k|
            next unless k['portName'] == downlink['portName']
            downlink['portUri'] = k['uri']
            downlink.delete('portName')
            break
          end
          raise("Downlink '#{downlink['portName']}' was not found or is already being monitored!") unless downlink['portUri']
        end
      end

      def add_interconnect
        noaction = proc do
          Chef::Log.info("Interconnect already created in #{@new_resource.enclosure} at bay #{@new_resource.bay_number}")
        end
        do_add = proc do |bay, enc|
          @context.converge_by "Add interconnect in #{@new_resource.enclosure} at bay #{@new_resource.bay_number}" do
            @item.create(bay, enc)
          end
        end
        interconnect_handler(noaction, do_add)
      end

      def remove_interconnect
        do_remove = proc do |bay, enc|
          @context.converge_by "Remove interconnect in #{@new_resource.enclosure} at bay #{@new_resource.bay_number}" do
            @item.delete(bay, enc)
          end
        end
        noaction = proc do
          Chef::Log.info("Interconnect not present in #{@new_resource.enclosure} at bay #{@new_resource.bay_number}")
        end
        interconnect_handler(do_remove, noaction)
      end

      def update_internal_networks
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        @new_resource.internal_networks.collect! { |n| load_resource(:EthernetNetwork, n) }
        if @item['internalNetworkUris'].sort == @new_resource.internal_networks.collect { |x| x['uri'] }.sort
          Chef::Log.info("Internal networks for #{@resource_name} #{@name} are up to date")
        else
          diff = get_diff(@item, 'internalNetworkUris' => @new_resource.internal_networks)
          Chef::Log.info "Updating internal networks for #{@resource_name} '#{@name}'#{diff}"
          @context.converge_by("Update internal networks for #{@resource_name} '#{@name}'") do
            @item.update_internal_networks(*@new_resource.internal_networks)
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
        new_data = Marshal.load(Marshal.dump(@item.data))
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        load_ports(new_data) if @new_resource.port_monitor.any?
        @item.data = new_data
        update_handler(:update_port_monitor, 'portMonitor')
      end

      def update_qos_configuration
        update_handler(:update_qos_configuration, 'qosConfiguration')
      end

      def update_telemetry_configuration
        update_handler(:update_telemetry_configuration, 'telemetryConfiguration')
      end

      def update_snmp_configuration
        traps = convert_keys(@new_resource.trap_destinations, :to_s)
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
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        # Nothing to verify
        @context.converge_by "Update #{@resource_name} '#{@name}' from group" do
          @item.compliance
        end
      end

      def reapply_configuration
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        # Nothing to verify
        @context.converge_by "Reapply configuration in #{@resource_name} '#{@name}'" do
          @item.configuration
        end
      end
    end
  end
end
