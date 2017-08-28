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
    # IDPool API200 provider
    class IDPoolProvider < ResourceProvider
      def create_or_update
        @item.get_pool(@new_resource.pool_type)
        Chef::Log.info "Updating #{@resource_name} '#{@name}'"
        @context.converge_by "#{@resource_name} '#{@name}' was updated." do
          @item.update(enabled: @new_resource.enabled)
        end
      end

      def allocate_list
        raise 'The IDs Pools list is not valid.' unless @item.validate_id_list(@new_resource.pool_type, @new_resource.id_list)
        Chef::Log.info "Allocating the IDs #{@new_resource.id_list} #{@resource_name} '#{@name}'"
        @context.converge_by "The IDs #{@new_resource.id_list} #{@resource_name} '#{@name}' were allocated." do
          @item.allocate_id_list(@new_resource.pool_type, @new_resource.id_list)
        end
      end

      def allocate_count
        Chef::Log.info "Allocating #{@new_resource.count} ID(s) #{@resource_name} '#{@name}'"
        @context.converge_by "#{@new_resource.count} ID(s) #{@resource_name} '#{@name}' were allocated." do
          @item.allocate_count(@new_resource.pool_type, @new_resource.count)
        end
      end

      def collect_ids
        Chef::Log.info "Removing the IDs #{@new_resource.id_list} #{@resource_name} '#{@name}'"
        @context.converge_by "The IDs #{@new_resource.id_list} #{@resource_name} '#{@name}'were removed." do
          @item.collect_ids(@new_resource.pool_type, @new_resource.id_list)
        end
      end
    end
  end
end
