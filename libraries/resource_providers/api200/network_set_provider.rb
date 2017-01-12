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

require_relative '../resource_provider'

module OneviewCookbook
  module API200
    # NetworkSet API200 provider
    class NetworkSetProvider < ResourceProvider
      def load_resource_with_properties
        item = load_resource
        if native_network
          native_net = resource_named(:EthernetNetwork).find_by(item.client, name: native_network).first
          raise "Native network #{native_network} not found!" unless native_net
          item.set_native_network(native_net)
        end

        if ethernet_network_list
          ethernet_network_list.each do |net_name|
            net = resource_named(:EthernetNetwork).find_by(item.client, name: net_name).first
            raise "Network #{net_name} not found!" unless net
            item.add_ethernet_network(net)
          end
        end
        item
      end

      # It should compare the networkUris regardless of how they are sorted in the array.
      # This actually is not supported by the Helper.oneview_api::Resource#like? and probably it will not be.
      def create_or_update
        ret_val = false
        item = load_resource_with_properties
        temp = Marshal.load(Marshal.dump(item.data))
        if item.exists?
          create_if_exists(item, temp)
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

      def create_if_exists(item, temp)
        item.retrieve!
        retrieved_networks = item.data.delete('networkUris')
        desired_networks = temp.delete('networkUris')
        temp['connectionTemplateUri'] ||= item['connectionTemplateUri']
        networks_match = retrieved_networks.to_a.sort == desired_networks.to_a.sort
        if item.like?(temp) && networks_match
          Chef::Log.info("#{resource_name} '#{name}' is up to date")
        else
          Chef::Log.info "Update #{resource_name} '#{name}'"
          Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
          Chef::Log.debug "Current state: #{JSON.pretty_generate(item.data)}"
          Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
          diff = get_diff(item, temp)
          diff << get_diff({ networkUris: retrieved_networks }, networkUris: desired_networks)
          converge_by "Update #{resource_name} '#{name}'#{diff}" do
            temp['networkUris'] = desired_networks
            item.update(temp)
          end
        end
      end

      def create_if_missing
      item = load_resource_with_properties
      create_if_missing(item)
    end
    end
  end
end
