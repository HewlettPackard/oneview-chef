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
        validate_required_properties(:storage_system, :storage_pool)
        storage_system_data = { credentials: { ip_hostname: @new_resource.storage_system }, name: @new_resource.storage_system }
        storage_system = load_resource(:StorageSystem, storage_system_data)
        storage_pool = load_resource(:StoragePool, name: @new_resource.storage_pool, storageSystemUri: storage_system['uri'])

        @item.set_storage_system(storage_system)
        @item['provisioning']['storagePoolUri'] = storage_pool['uri']
        @item['provisioning']['capacity'] = @item['provisioning']['capacity'].to_s if @item['provisioning'] && @item['provisioning']['capacity']
        @item.set_snapshot_pool(load_resource(:StoragePool, name: @new_resource.snapshot_pool, storageSystemUri: storage_system['uri'])) if @new_resource.snapshot_pool
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
