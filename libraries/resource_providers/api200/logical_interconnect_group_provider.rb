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
    # LogicalInterconnectGroup API200 provider
    class LogicalInterconnectGroupProvider < ResourceProvider
      def load_interconnects
        @new_resource.interconnects.each do |location|
          parsed_location = convert_keys(location, :to_sym)
          @item.add_interconnect(parsed_location[:bay], parsed_location[:type])
        end
      end

      def load_uplink_sets
        @new_resource.uplink_sets.each do |uplink_info|
          parsed_uplink_info = convert_keys(uplink_info, :to_sym)
          up = resource_named(:LIGUplinkSet).new(@item.client, parsed_uplink_info[:data])
          parsed_uplink_info[:networks].each do |network_name|
            net = case up[:networkType].to_s
                  when 'Ethernet'
                    load_resource(:EthernetNetwork, network_name)
                  when 'FibreChannel'
                    load_resource(:FCNetwork, network_name)
                  else
                    raise "Type '#{up[:networkType]}' not supported"
                  end
            up.add_network(net)
          end
          parsed_uplink_info[:connections].each do |link|
            enclosure_index = link[:enclosure_index] || 1
            up.add_uplink(link[:bay], link[:port], link[:type], enclosure_index)
          end
          @item.add_uplink_set(up)
        end
      end

      def create_or_update
        load_interconnects
        load_uplink_sets
        super
      end

      def create_if_missing
        load_interconnects
        load_uplink_sets
        super
      end
    end
  end
end
