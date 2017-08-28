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

module OneviewCookbook
  module API200
    # UplinkSet API200 provider
    class UplinkSetProvider < ResourceProvider
      # Checks for external resources to be loaded within the @item
      def load_native_network
        return @item['nativeNetworkUri'] = nil unless @new_resource.native_network
        # Retrieves the uplink set type based on the declared networkType parameter
        # Takes either Ethernet (default) or FibreChannel
        network_type = @item['networkType'] == 'Ethernet' ? 'EthernetNetwork' : 'FCNetwork'
        @item['nativeNetworkUri'] = load_resource(network_type, native_network, 'uri')
      end

      def load_networks(network_list, type)
        return unless network_list
        return @item['networkUris'] = [] if network_list.empty?
        network_list.each do |net_name|
          net = load_resource(type, net_name)
          case type.to_sym
          when :EthernetNetwork then @item.add_network(net)
          when :FCNetwork then @item.add_fcnetwork(net)
          when :FCoENetwork then @item.add_fcoenetwork(net)
          else
            raise "UnsuportedType: The #{type} is not supported for #{@resource_name}"
          end
        end
      end

      # Looks for enclosures within Location Entries
      # An IF statement by itself would try to iterate and raise an exception if locationEntries does not exist
      def load_enclosure
        return unless defined? @item.data['portConfigInfos'][0]['location']['locationEntries']
        @item.data['portConfigInfos'][0]['location']['locationEntries'].each do |entry|
          # Checks whether the Enclosure has been declared, and sets its URI in case the user has referenced it by name
          # If the URI is already present, the following block is simply skipped
          next unless entry && entry['type'] == 'Enclosure' && !entry['value'].to_s[0..17].include?('/rest/enclosures/')
          entry['value'] = load_resource(:Enclosure, { name: entry['value'], uri: entry['value'] }, 'uri')
        end
      end

      # Broken-down method calls
      def load_resource_with_properties
        load_native_network
        load_networks(@new_resource.networks, :EthernetNetwork)
        load_networks(@new_resource.fc_networks, :FCNetwork)
        load_networks(@new_resource.fcoe_networks, :FCoENetwork)
        @item.set_logical_interconnect(load_resource(:LogicalInterconnect, @new_resource.logical_interconnect)) if @new_resource.logical_interconnect
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
