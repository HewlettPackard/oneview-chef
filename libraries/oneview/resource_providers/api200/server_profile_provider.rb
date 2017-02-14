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

require_relative '../../../resource_provider'

module OneviewCookbook
  module API200
    # ServerProfile API200 provider
    class ServerProfileProvider < ResourceProvider
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

      def set_connections(type, connection_list)
        return false unless connection_list
        type = resource_named(type) unless type.respond_to?(:const_get)
        connection_list.each do |net_name, options|
          res = type.find_by(@item.client, name: net_name).first
          raise "Resource not found: #{type} '#{net_name}' could not be found." unless res
          @item.add_connection(res, options)
        end
        true
      end

      def set_resource(type, name, method, args = [])
        return false unless name
        type = resource_named(type) unless type.respond_to?(:const_get)
        res = type.find_by(@item.client, name: name).first
        raise "Resource not found: #{type} '#{name}' could not be found." unless res
        @item.public_send(method, res, *args)
        true
      end

      def create_or_update
        load_with_properties
        super
      end

      def create_if_missing
        load_with_properties
        super
      end
    end
  end
end
