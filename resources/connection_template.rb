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

default_action :update

property :associated_ethernet_network, String

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase

  def load_resource_from_ethernet
    item = load_resource
    if associated_ethernet_network
      item.data.delete('name')
      ethernet = OneviewSDK::EthernetNetwork.find_by(item.client, name: associated_ethernet_network).first
      item['uri'] = ethernet['connectionTemplateUri']
    end
    item
  end
end

action :update do
  create_or_update(load_resource_from_ethernet)
end

action :reset do
  item = load_resource_from_ethernet
  item['bandwidth'] = OneviewSDK::ConnectionTemplate.get_default(item.client)['bandwidth']
  create_or_update(item)
end
