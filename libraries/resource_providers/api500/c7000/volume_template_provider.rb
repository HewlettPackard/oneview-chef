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
  module API500
    module C7000
      # VolumeTemplate API500 C7000 provider
      class VolumeTemplateProvider < API300::C7000::VolumeTemplateProvider
        # Loads the VolumeTemplate with all the external resources (if needed)
        def load_resource_with_associated_resources
          @item.set_root_template(load_root_template)
          @item.set_default_value('storagePool', load_storage_pool)
          @item.set_default_value('snapshotPool', load_snapshot_pool) if @new_resource.snapshot_pool
        end

        # Loads the Snapshot Pool
        # @return [resource_named(:StoragePool)] The Snapshot Pool loaded
        def load_snapshot_pool
          load_storage_system unless @storage_system
          resource_named(:StoragePool).find_by(@item.client, name: @new_resource.snapshot_pool, storageSystemUri: @storage_system['uri']).first
        end

        # Loads the Storage System
        # The property storage_system needs to be used in the recipe for this code to load the Storage System.
        # Hostname or storage system name can be used
        # @return [resource_named(:StorageSystem)] The StorageSystem loaded
        def load_storage_system
          raise "Unspecified property: 'storage_system'. Please set it before attempting this action." unless @new_resource.storage_system
          @storage_system = resource_named(:StorageSystem).find_by(@item.client, name: @new_resource.storage_system).first
          @storage_system ||= resource_named(:StorageSystem).find_by(@item.client, hostname: @new_resource.storage_system).first
          @storage_system || raise("'storage_system' #{@new_resource.storage_system} not found. Please set a valid 'storage_system' before.")
        end

        # Loads the Root Template
        # @return [resource_named(:StorageSystem)] The Root Template loaded
        def load_root_template
          load_storage_system unless @storage_system
          @storage_system.get_templates.find { |i| i['isRoot'] }
        end
      end
    end
  end
end
