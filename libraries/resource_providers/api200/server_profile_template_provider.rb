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

require_relative 'server_profile_provider'

module OneviewCookbook
  module API200
    # ServerProfileTemplate API200 provider
    class ServerProfileTemplateProvider < ServerProfileProvider
      def load_with_properties
        set_resource(:ServerHardwareType, @context.server_hardware_type, :set_server_hardware_type)
        set_resource(:EnclosureGroup, @context.enclosure_group, :set_enclosure_group)
        set_resource(:FirmwareDriver, @context.firmware_driver, :set_firmware_driver)
        set_connections(:EthernetNetwork, @context.ethernet_network_connections)
        set_connections(:FCNetwork, @context.fc_network_connections)
        set_connections(:NetworkSet, @context.network_set_connections)
      end

      def new_profile
        raise "Unspecified property: 'profile_name'. Please set it before attempting this action." unless @context.profile_name
        raise "Resource not found: '#{@name}' could not be found." unless @item.exists?
        @item.retrieve!
        @item = @item.new_profile(@context.profile_name)
        create_if_missing
      end
    end
  end
end
