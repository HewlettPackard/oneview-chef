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
OneviewCookbook::Helper.load_sdk(self)
OneviewCookbook::Helper.load_attributes(self)

default_action :create

action_class do
  include OneviewCookbook::Helper::provider_api::EthernetNetworkProvider
end

action :create do
  create_ethernet_network
end

action :create_if_missing do
  create_ethernet_network_if_missing
end

action :reset_connection_template do
  reset_ethernet_network_connection_template
end

action :delete do
  delete_ethernet_network
end
