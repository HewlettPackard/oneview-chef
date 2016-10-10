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
property :networks, Array
property :fc_networks, Array
property :fcoe_networks, Array
property :logical_interconnect, String

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
  def load_resource_with_properties
    item = load_resource
    if native_network
      if native_network.nil? || native_network == 'nil'
        item['nativeNetworkUri'] = nil
      else
        native_net = OneviewSDK::EthernetNetwork.find_by(item.client, name: native_network).first
        raise "Network #{native_network} not found." unless native_net
        item['nativeNetworkUri'] = native_net['uri']
      end
    end
    if networks
      if networks.empty?
        item['networkUris'] = []
      else
        networks.each do |net_name|
          net = OneviewSDK::EthernetNetwork.find_by(item.client, name: net_name).first
          raise "Ethernet Network #{net_name} not found." unless net
          item.add_network(net)
        end
      end
    end
    if fc_networks
      if fc_networks.empty?
        item['fcNetworkUris'] = []
      else
        fc_networks.each do |net_name|
          net = OneviewSDK::FCNetwork.find_by(item.client, name: net_name).first
          raise "FC Network #{net_name} not found." unless net
          item.add_fcnetwork(net)
        end
      end
    end
    if fcoe_networks
      if fcoe_networks.empty?
        item['fcoeNetworkUris'] = []
      else
        fcoe_networks.each do |net_name|
          net = OneviewSDK::FCoENetwork.find_by(item.client, name: net_name).first
          raise "FCoE Network #{net_name} not found." unless net
          item.add_fcoenetwork(net)
        end
      end
    end
    if logical_interconnect
      li = OneviewSDK::LogicalInterconnect.find_by(item.client, name: logical_interconnect).first
      raise "Logical Interconnect #{logical_interconnect} not found." unless li
      item.set_logical_interconnect(li)
    end
    # Looks for enclosures within Location Entries
    # An IF statement by itself would try to iterate and raise an exception if locationEntries does not exist
    if defined? item.data['portConfigInfos'][0]['location']['locationEntries']
      item.data['portConfigInfos'][0]['location']['locationEntries'].each do |entry|
        if entry && entry['type'] == 'Enclosure'
          enclosure = OneviewSDK::Enclosure.find_by(item.client, name: entry['value']).first
          raise "Enclosure #{entry['value']} not found." unless enclosure
          entry['value'] = enclosure['uri']
        end
      end
    end
    item
  end
end

action :create do
  # puts load_resource_with_properties.data
  create_or_update(load_resource_with_properties)
end

action :create_if_missing do
  create_if_missing(load_resource_with_properties)
end

action :delete do
  delete
end
