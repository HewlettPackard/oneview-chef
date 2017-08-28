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
    # EnclosureGroup API200 provider
    class EnclosureGroupProvider < ResourceProvider
      def load_lig # Deprecated property: logical_interconnect_group
        return unless @new_resource.logical_interconnect_group
        lig_klass = resource_named(:LogicalInterconnectGroup)
        dep_warn = "The 'logical_interconnect_group' property (string) is deprecated!"
        Chef::Log.warn("#{dep_warn} Please use 'logical_interconnect_groups' property (array) instead")
        @item.add_logical_interconnect_group(lig_klass.new(@item.client, name: @new_resource.logical_interconnect_group))
      end

      def load_ligs
        load_lig # Deprecated method
        return unless @new_resource.logical_interconnect_groups
        lig_klass = resource_named(:LogicalInterconnectGroup)
        @new_resource.logical_interconnect_groups.each do |lig|
          lig_name = lig.class == Hash ? convert_keys(lig, :to_s)['name'] : lig
          @item.add_logical_interconnect_group(lig_klass.new(@item.client, name: lig_name))
        end
      end

      def create_or_update
        load_ligs
        super
      end

      def create_if_missing
        load_ligs
        super
      end

      def set_script
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        return Chef::Log.info("#{@resource_name} '#{@name}' script is up to date") if @item.get_script.eql?(@new_resource.script)
        Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
        @context.converge_by "Updated script for #{@resource_name} '#{@name}'" do
          @item.set_script(@new_resource.script)
        end
      end
    end
  end
end
