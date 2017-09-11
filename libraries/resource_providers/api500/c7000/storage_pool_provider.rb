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

require_relative 'storage_system_provider'

module OneviewCookbook
  module API500
    module C7000
      # StoragePool API500 C7000 provider
      class StoragePoolProvider < API300::C7000::StoragePoolProvider
        include API500::C7000::StorageProviderHelper # Adds refresh operation

        def load_storage_system
          raise("Unspecified property: 'storage_system'. Please set it before attempting this action.") unless @new_resource.storage_system
          data = {
            hostname: @new_resource.storage_system,
            name: @new_resource.storage_system
          }
          @item.set_storage_system(load_resource(:StorageSystem, data))
        end

        def update_manage_state(managed)
          status = 'managed'
          status = 'unmanaged' unless @item['isManaged']
          return Chef::Log.info("#{@resource_name} '#{@name}' is already #{status}") if @item['isManaged'] == managed
          @context.converge_by "#{@resource_name} '#{@name}' is now #{status}" do
            @item.update(isManaged: managed)
          end
        end

        def add_for_management
          load_storage_system
          @item.retrieve! || raise("Resource not found: The #{@resource_name} '#{@name}' could not be found")
          update_manage_state(true)
        end

        def remove_from_management
          load_storage_system
          @item.retrieve! || raise("Resource not found: The #{@resource_name} '#{@name}' could not be found")
          update_manage_state(false)
        end

        def add_if_missing
          Chef::Log.warn("The #{@resource_name} in API #{@sdk_api_version} variant #{@sdk_variant} cannot perform 'add_if_missing' operation. Performing 'add_for_management' instead...")
          add_for_management
        end

        def remove
          Chef::Log.warn("The #{@resource_name} in API #{@sdk_api_version} variant #{@sdk_variant} cannot perform 'remove' operation. Performing 'remove_from_management' instead...")
          remove_from_management
        end

        def update
          load_storage_system
          @item.retrieve! || raise("Resource not found: The #{@resource_name} '#{@name}' could not be found")
          update_manage_state(@data['isManaged'])
          diff = get_diff(@item, @data)
          return Chef::Log.info("#{@resource_name} '#{@name}' has no need to update") if diff =~ /no diff/
          @context.converge_by "Updated the #{@resource_name} '#{@name}'#{diff}" do
            @item.update(@data)
          end
        end
      end
    end
  end
end
