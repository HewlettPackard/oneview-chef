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
    # Datacenter API200 provider
    class DatacenterProvider < ResourceProvider
      def add_racks
        @new_resource.racks.each do |rack_name, rack_position|
          rack = load_resource(:Rack, rack_name.to_s)
          rp = convert_keys(rack_position, :to_sym)
          x = rp[:x] || 0
          y = rp[:y] || 0
          rotation = rp[:rotation] || 0
          @item.add_rack(rack, x, y, rotation)
        end
      end

      def add_or_edit
        add_racks
        super
      end

      def add_if_missing
        add_racks
        super
      end
    end
  end
end
