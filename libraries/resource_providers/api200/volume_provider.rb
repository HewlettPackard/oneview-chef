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
    # Volume API200 provider
    class VolumeProvider < ResourceProvider
      # Loads the Volume with all the external resources (if needed)
      def load_resource_with_associated_resources
        if @context.volume_template
          @item.set_storage_volume_template(resource_named(:VolumeTemplate).new(@item.client, name: @context.volume_template))
        else # Can't set the storage_pool or snapshot_pool if we specify a volume_template
          load_storage_system if @context.storage_system
          # @item.set_storage_pool(resource_named(:StoragePool).new(@item.client, name: storage_pool)) if storage_pool
          # Workaround for issue in oneview-sdk:
          load_storage_pool if @context.storage_pool
          load_snapshot_pool if @context.snapshot_pool
        end

        # Convert capacity integers to strings
        @item['provisionedCapacity'] = @item['provisionedCapacity'].to_s if @item['provisionedCapacity']
        @item['allocatedCapacity'] = @item['allocatedCapacity'].to_s if @item['allocatedCapacity']

        set_provisioning_parameters unless @item.exists? # Also set provisioningParameters if the volume does not exist
      end

      # Loads Storage System into the given Volume resource.
      # The storage_system property needs to be set to a name or IP in order to use this method
      def load_storage_system
        data = {
          credentials: { ip_hostname: @context.storage_system },
          name: @context.storage_system
        }
        @item.set_storage_system(load_resource(:StorageSystem, data))
      end

      def load_storage_pool
        raise 'Must specify a storage_system to use the storage_pool helper.' unless @item['storageSystemUri']
        sp = resource_named(:StoragePool).find_by(@item.client, name: @context.storage_pool, storageSystemUri: @item['storageSystemUri']).first
        raise "Storage Pool '#{sp['name']}' not found" unless sp
        @item['storagePoolUri'] = sp['uri']
      end

      def load_snapshot_pool
        raise 'Must specify a storage_system to use the storage_pool helper.' unless @item['storageSystemUri']
        snap = resource_named(:StoragePool).find_by(@item.client, name: @context.snapshot_pool, storageSystemUri: @item['storageSystemUri']).first
        @item.set_snapshot_pool(snap)
      end

      def set_provisioning_parameters
        @item['provisioningParameters'] ||= {}
        shareable = !@item['shareable'].nil? && @item['provisioningParameters']['shareable'].nil?
        @item['provisioningParameters']['shareable'] = @item['shareable'] if shareable
        @item['provisioningParameters']['provisionType'] ||= @item['provisionType'] if @item['provisionType']
        @item['provisioningParameters']['requestedCapacity'] ||= @item['provisionedCapacity'] if @item['provisionedCapacity']
        @item['provisioningParameters']['storagePoolUri'] ||= @item['storagePoolUri'] if @item['storagePoolUri']
        @item.data.delete('provisioningParameters') if @item['provisioningParameters'].empty?
      end

      def create_or_update
        load_resource_with_associated_resources
        super
      end

      def create_if_missing
        load_resource_with_associated_resources
        super
      end

      def create_snapshot
        raise "UnspecifiedProperty: 'snapshot_data'. Please set it before attempting this action." unless @context.snapshot_data
        temp = convert_keys(Marshal.load(Marshal.dump(@context.snapshot_data)), :to_s)
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        snapshot = @item.get_snapshot(temp['name'])
        return Chef::Log.info "Volume snapshot '#{temp['name']}' already exists" unless snapshot.empty?
        Chef::Log.info "Creating oneview_volume '#{@name}' snapshot"
        @context.converge_by "Created oneview_volume '#{@name}' snapshot" do
          @item.create_snapshot(temp)
        end
      end

      def delete_snapshot
        raise "UnspecifiedProperty: 'snapshot_data'. Please set it before attempting this action." unless @context.snapshot_data
        temp = convert_keys(Marshal.load(Marshal.dump(@context.snapshot_data)), :to_s)
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        snapshot = @item.get_snapshot(temp['name'])
        return Chef::Log.info "Volume snapshot '#{temp['name']}' already exists" if snapshot.empty?
        Chef::Log.info "Deleting oneview_volume_snapshot '#{@name}'"
        @context.converge_by "Deleted oneview_volume_snapshot '#{@name}'" do
          @item.delete_snapshot(temp['name'])
        end
      end
    end
  end
end
