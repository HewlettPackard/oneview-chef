# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

OneviewCookbook::ResourceBaseProperties.load(self)

default_action :create

property :server_hardware_type, String
property :enclosure_group, String
property :firmware_driver, String
property :ethernet_network_connections, Hash
property :network_set_connections, Hash
property :fc_network_connections, Hash
property :profile_name, String

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase

  # Loads the Volume with all the external resources (if needed)
  # @return [OneviewSDK::Volume] Loaded Volume resource
  def load_with_properties
    item = load_resource
    set_resource(item, OneviewSDK::ServerHardwareType, server_hardware_type, :set_server_hardware_type)
    set_resource(item, OneviewSDK::EnclosureGroup, enclosure_group, :set_enclosure_group)
    set_resource(item, OneviewSDK::FirmwareDriver, firmware_driver, :set_firmware_driver)
    set_connections(item, OneviewSDK::EthernetNetwork, ethernet_network_connections)
    set_connections(item, OneviewSDK::FCNetwork, fc_network_connections)
    set_connections(item, OneviewSDK::NetworkSet, network_set_connections)
  end

  def set_connections(item, type, connection_list)
    return false unless connection_list
    connection_list.each do |net_name, options|
      res = type.find_by(item.client, name: net_name).first
      raise "Resource not found: #{type} '#{net_name}' could not be found." unless res
      item.add_connection(res, options)
    end
    true
  end

  def set_resource(item, type, name, method, args = nil)
    return false unless name
    res = type.find_by(item.client, name: name).first
    raise "Resource not found: #{type} '#{name}' could not be found." unless res
    item.public_send(method, res, *args)
    true
  end
end

action :create do
  create_or_update(load_with_properties)
end

action :create_if_missing do
  create_if_missing(load_with_properties)
end

action :delete do
  delete
end

action :new_profile do
  raise "Unspecified property: 'profile_name'. Please set it before attempting this action." unless profile_name
  item = load_resource
  raise "Resource not found: '#{name}' could not be found." unless item.exists?
  item.retrieve!
  profile = item.new_profile(profile_name)
  create_if_missing(profile)
end
