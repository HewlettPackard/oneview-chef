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
    # VolumeTemplate API200 provider
    class VolumeTemplateProvider < ResourceProvider
      # Loads the VolumeTemplate with all the external resources (if needed)
      def load_resource_with_associated_resources
        @item['provisioning']['capacity'] = @item['provisioning']['capacity'].to_s if @item['provisioning'] && @item['provisioning']['capacity']
        @item.set_storage_system(load_storage_system)
        @item['provisioning']['storagePoolUri'] = load_storage_pool['uri']
        @item.set_snapshot_pool(resource_named(:StoragePool).new(@item.client, name: @new_resource.snapshot_pool)) if @new_resource.snapshot_pool
      end

      # Loads the Storage Pool
      # @raise [RuntimeError] if property 'storage_pool' is not set or Storage Pool resource not found
      # @return [resource_named(:StoragePool)] The Storage Pool loaded
      def load_storage_pool
        load_storage_system unless @storage_system
        raise "Unspecified property: 'storage_pool'. Please set it before attempting this action." unless @new_resource.storage_pool
        @storage_pool = resource_named(:StoragePool).find_by(@item.client, name: @new_resource.storage_pool, storageSystemUri: @storage_system['uri']).first
        raise "Storage Pool '#{@new_resource.storage_pool}' not found for Storage System '#{@new_resource.storage_system}'" unless @storage_pool
        @storage_pool
      end

      # Loads the Storage System
      # The property storage_system needs to be used in the recipe for this code to load the Storage System.
      # Hostname or storage system name can be used
      # @return [resource_named(:StorageSystem)] The StorageSystem loaded
      def load_storage_system
        raise "Unspecified property: 'storage_system'. Please set it before attempting this action." unless @new_resource.storage_system
        data = {
          credentials: { ip_hostname: @new_resource.storage_system },
          name: @new_resource.storage_system
        }
        @storage_system = load_resource(:StorageSystem, data)
      end

      def create_or_update
        load_resource_with_associated_resources
        super
      end

      def create_if_missing
        load_resource_with_associated_resources
        super
      end
    end
  end
end
