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

property :server_hardware, String
property :server_hardware_type, String
property :enclosure_group, String
property :enclosure, String
property :firmware_driver, String
property :ethernet_network_connections, Object
property :fc_network_connections, Object
property :fcoe_network_connections, Object
property :network_set_connections, Object
property :server_profile_template, String
property :os_deployment_plan, String
property :volume_attachments, Array, default: []

default_action :create

action :create do
  OneviewCookbook::Helper.do_resource_action(self, :ServerProfile, :create_or_update)
end

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :ServerProfile, :create_if_missing)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :ServerProfile, :delete)
end

action :update_from_template do
  OneviewCookbook::Helper.do_resource_action(self, :ServerProfile, :update_from_template)
end
