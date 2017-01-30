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

require_relative '../../resource_provider'

module OneviewCookbook
  module API200
    # UplinkSet API200 provider
    class UplinkSetProvider < ResourceProvider
      # Checks for external resources to be loaded within the @item
      def load_native_network
        unless @context.native_network
          @item['nativeNetworkUri'] = nil
          return
        end
        # Retrieves the uplink set type based on the declared networkType parameter
        # Takes either Ethernet (default) or FibreChannel
        network_type = @item['networkType'] == 'Ethernet' ? 'EthernetNetwork' : 'FCNetwork'
        native_net = resource_named(network_type.to_sym).find_by(@item.client, name: native_network).first
        raise "Network #{native_network} not found." unless native_net
        @item['nativeNetworkUri'] = native_net['uri']
      end

      def load_networks(network_list, type)
        return unless network_list
        type = resource_named(type.to_sym) unless type.respond_to?(:find_by)
        return @item['networkUris'] = [] if network_list.empty?
        network_list.each do |net_name|
          net = type.find_by(@item.client, name: net_name).first
          raise "#{type} #{net_name} not found." unless net
          @item.add_network(net) if type == resource_named(:EthernetNetwork)
          @item.add_fcnetwork(net) if type == resource_named(:FCNetwork)
          @item.add_fcoenetwork(net) if type == resource_named(:FCoENetwork)
        end
      end

      def load_logical_interconnect
        return unless @context.logical_interconnect
        li = resource_named(:LogicalInterconnect).find_by(@item.client, name: @context.logical_interconnect).first
        raise "Logical Interconnect #{@context.logical_interconnect} not found." unless li
        @item.set_logical_interconnect(li)
      end

      # Looks for enclosures within Location Entries
      # An IF statement by itself would try to iterate and raise an exception if locationEntries does not exist
      def load_enclosure
        return unless defined? @item.data['portConfigInfos'][0]['location']['locationEntries']
        @item.data['portConfigInfos'][0]['location']['locationEntries'].each do |entry|
          # Checks whether the Enclosure has been declared, and sets its URI in case the user has referenced it by name
          # If the URI is already present, the following block is simply skipped
          next unless entry && entry['type'] == 'Enclosure' && !entry['value'].to_s[0..17].include?('/rest/enclosures/')
          enclosure = resource_named(:Enclosure).find_by(@item.client, name: entry['value']).first
          raise "Enclosure #{entry['value']} not found." unless enclosure
          entry['value'] = enclosure['uri']
        end
      end

      # Broken-down method calls
      def load_resource_with_properties
        load_native_network
        load_networks(@context.networks, :EthernetNetwork)
        load_networks(@context.fc_networks, :FCNetwork)
        load_networks(@context.fcoe_networks, :FCoENetwork)
        load_logical_interconnect
        load_enclosure
      end

      def create_or_update
        load_resource_with_properties
        super
      end

      def create_if_missing
        load_resource_with_properties
        super
      end
    end
  end
end
