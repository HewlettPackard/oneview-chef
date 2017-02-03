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

property :native_network, String       # Native network name
property :networks, Array              # Array of strings containing Ethernet Network names
property :fc_networks, Array           # Array of strings containing FC network names
property :fcoe_networks, Array         # Array of strings containing FCoE Network names
property :logical_interconnect, String # Associated logical interconnect name

default_action :create

action :create do
  OneviewCookbook::Helper.do_resource_action(self, :UplinkSet, :create_or_update)
end

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :UplinkSet, :create_if_missing)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :UplinkSet, :delete)
end
