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
  module API300
    module Synergy
      # LogicalInterconnectGroup API300 Synergy resource provider methods
      class LogicalInterconnectGroupProvider < API200::LogicalInterconnectGroupProvider
        def load_interconnects
          @new_resource.interconnects.each do |location|
            parsed_location = convert_keys(location, :to_sym)
            @item.add_interconnect(
              parsed_location[:bay],
              parsed_location[:type],
              parsed_location[:logical_downlink] || nil,
              parsed_location[:enclosure_index] || 1
            )
          end
        end
      end
    end
  end
end
