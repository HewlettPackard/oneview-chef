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
      # EnclosureGroup API300 Synergy resource provider methods
      class EnclosureGroupProvider < API200::EnclosureGroupProvider
        def load_ligs
          load_lig # Deprecated method
          return unless @new_resource.logical_interconnect_groups
          lig_klass = resource_named(:LogicalInterconnectGroup)
          sas_lig_klass = resource_named(:SASLogicalInterconnectGroup)
          @new_resource.logical_interconnect_groups.each do |lig|
            lig_name = lig.class == Hash ? convert_keys(lig, :to_s)['name'] : lig
            index = lig.class == Hash ? convert_keys(lig, :to_s)['enclosureIndex'] : nil
            begin
              @item.add_logical_interconnect_group(lig_klass.new(@item.client, name: lig_name), index)
            rescue OneviewSDK::NotFound
              # Look for and add the SAS LIG if no standard LIG was found
              @item.add_logical_interconnect_group(sas_lig_klass.new(@item.client, name: lig_name), index)
            end
          end
        end
      end
    end
  end
end
