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
    # LogicalSwitchGroup API200 provider
    class LogicalSwitchGroupProvider < ResourceProvider
      def load_logical_switch_group
        # This will avoid overriding the 'switchMapTemplate' if already specified in data
        return unless @item['switchMapTemplate'].empty?
        raise "Unspecified property: 'switch_number'. Please set it before attempting this action." unless @new_resource.switch_number
        raise "Unspecified property: 'switch_type'. Please set it before attempting this action." unless @new_resource.switch_type
        @item.set_grouping_parameters(@new_resource.switch_number, @new_resource.switch_type)
      end

      def create_or_update
        load_logical_switch_group
        super
      end

      def create_if_missing
        load_logical_switch_group
        super
      end
    end
  end
end
