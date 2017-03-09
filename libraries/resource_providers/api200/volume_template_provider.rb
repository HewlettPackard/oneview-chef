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

require_relative '../../resource_provider'

module OneviewCookbook
  module API200
    # VolumeTemplate API200 provider
    class VolumeTemplateProvider < ResourceProvider
      # Loads the VolumeTemplate with all the external resources (if needed)
      def load_resource_with_associated_resources
        raise "Unspecified property: 'storage_system'. Please set it before attempting this action." unless @context.storage_system
        raise "Unspecified property: 'storage_pool'. Please set it before attempting this action." unless @context.storage_pool
        @item['provisioning']['capacity'] = @item['provisioning']['capacity'].to_s if @item['provisioning'] && @item['provisioning']['capacity']
        load_storage_system
        sp = resource_named(:StoragePool).find_by(@item.client, name: @context.storage_pool, storageSystemUri: @item['storageSystemUri']).first
        raise "Storage Pool '#{@context.storage_pool}' not found for Storage System '#{@context.storage_system}'" unless sp
        @item['provisioning']['storagePoolUri'] = sp['uri']
        @item.set_snapshot_pool(resource_named(:StoragePool).new(@item.client, name: @context.snapshot_pool)) if @context.snapshot_pool
      end

      # Loads Storage System in the given VolumeTemplate resource.
      # The property storage_system needs to be used in the recipe for this code to load the Storage System.
      # Hostname or storage system name can be used
      # @return [resource_named(:VolumeTemplate)] VolumeTemplate with Storage System parameters updated
      def load_storage_system
        data = {
          credentials: { ip_hostname: @context.storage_system },
          name: @context.storage_system
        }
        @item.set_storage_system(load_resource(:StorageSystem, data))
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
