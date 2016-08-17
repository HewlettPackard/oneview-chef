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

property :native_network, String
property :ethernet_network_list, Array # Array containing network names

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
  def load_resource_with_properties
    item = load_resource
    if native_network
      native_net = OneviewSDK::EthernetNetwork.new(item.client, name: native_network)
      native_net.retrieve!
      item.set_native_network(native_net)
    end

    if ethernet_network_list
      ethernet_network_list.each do |net_name|
        net = OneviewSDK::EthernetNetwork.new(item.client, name: net_name)
        net.retrieve!
        item.add_ethernet_network(net)
      end
    end
    item
  end
end

# It should compare the networkUris regardless of how they are sorted in the array.
# This actually is not supported by the OneviewSDK::Resource#like? and probably it will not be.
action :create do
  ret_val = false
  item = load_resource_with_properties
  temp = item.data.clone
  if item.exists?
    item.retrieve!
    retrieved_networks = item.data.delete('networkUris')
    current_networks = temp.delete('networkUris')
    temp['connectionTemplateUri'] ||= item['connectionTemplateUri']
    networks_match = retrieved_networks.sort == current_networks.sort
    if item.like?(temp) && networks_match
      Chef::Log.info("#{resource_name} '#{name}' is up to date")
    else
      Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
      Chef::Log.info "Update #{resource_name} '#{name}'"
      converge_by "Update #{resource_name} '#{name}'" do
        temp['networkUris'] = current_networks
        item.update(temp)
      end
    end
  else
    Chef::Log.info "Create #{resource_name} '#{name}'"
    converge_by "Create #{resource_name} '#{name}'" do
      item.create
    end
    ret_val = true
  end
  save_res_info(save_resource_info, name, item)
  ret_val
end

action :create_if_missing do
  item = load_resource_with_properties
  create_if_missing(item)
end

action :delete do
  delete
end
