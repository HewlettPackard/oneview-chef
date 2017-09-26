# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

property :bay_number, Integer
property :enclosure, String
property :internal_networks, Array, default: []
property :trap_destinations, Hash, default: {}
property :firmware, String
property :firmware_data, Hash, default: {}
property :scopes, Array
property :port_monitor, Hash, default: {}

default_action :none

action :none do
end

action :add_interconnect do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :add_interconnect)
end

action :remove_interconnect do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :remove_interconnect)
end

action :update_internal_networks do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_internal_networks)
end

action :update_settings do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_settings)
end

action :update_ethernet_settings do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_ethernet_settings)
end

action :update_port_monitor do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_port_monitor)
end

action :update_qos_configuration do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_qos_configuration)
end

action :update_telemetry_configuration do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_telemetry_configuration)
end

action :update_snmp_configuration do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_snmp_configuration)
end

action :update_firmware do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_firmware)
end

action :stage_firmware do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :stage_firmware)
end

action :activate_firmware do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :activate_firmware)
end

action :update_from_group do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :update_from_group)
end

action :reapply_configuration do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :reapply_configuration)
end

action :add_to_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :add_to_scopes)
end

action :remove_from_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :remove_from_scopes)
end

action :replace_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :replace_scopes)
end

action :patch do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalInterconnect, :patch)
end
