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
    # Helper module for
    module ServerProfileProviderHelpers
      def set_connections(type, connection_list)
        return false unless connection_list
        connection_list.each { |net_name, options| @item.add_connection(load_resource(type, net_name), options) }
        true
      end

      def set_resource(type, name, method, args = [])
        return false unless name
        @item.public_send(method, load_resource(type, name), *args)
        true
      end
    end

    # ServerProfile API200 provider
    class ServerProfileProvider < ResourceProvider
      include ServerProfileProviderHelpers
      # Loads the Server profile with all the external resources (if needed)
      def load_with_properties
        set_resource(:ServerHardware, @context.server_hardware, :set_server_hardware)
        set_resource(:ServerHardwareType, @context.server_hardware_type, :set_server_hardware_type)
        set_resource(:EnclosureGroup, @context.enclosure_group, :set_enclosure_group)
        set_resource(:Enclosure, @context.enclosure, :set_enclosure)
        set_resource(:FirmwareDriver, @context.firmware_driver, :set_firmware_driver)
        set_connections(:EthernetNetwork, @context.ethernet_network_connections)
        set_connections(:FCNetwork, @context.fc_network_connections)
        set_connections(:NetworkSet, @context.network_set_connections)
      end

      # Override create method to allow creation from a template
      def create(method)
        if @context.server_profile_template
          template = load_resource(:ServerProfileTemplate, @context.server_profile_template)
          Chef::Log.info "Using template '#{@context.server_profile_template}' to #{method} #{@resource_name} '#{@name}'"
          new_profile_data = template.new_profile(@item['name']).data
          @item.data = new_profile_data.merge(@item.data)
        end
        super
      end

      def create_or_update
        load_with_properties
        super
      end

      def create_if_missing
        load_with_properties
        super
      end

      def update_from_template
        raise "#{@resource_name} '#{@item['name']}' was not found!" unless @item.retrieve!
        if @item['templateCompliance'] == 'Compliant'
          Chef::Log.info("#{@resource_name} '#{@item['name']}' is up to date")
        else
          preview = JSON.pretty_generate(@item.get_compliance_preview) rescue 'ERROR: Failed to retrieve compliance preview.'
          Chef::Log.info "Updating #{@resource_name} '#{@item['name']}' from template. Compliance Preview: #{preview}"
          @context.converge_by "Update #{@resource_name} '#{@item['name']}' from template" do
            @item.update_from_template
          end
        end
      end
    end
  end
end
