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
    # Volume API200 provider
    class VolumeProvider < ResourceProvider
      # Loads the Volume with all the external resources (if needed)
      def load_resource_with_associated_resources
        if @new_resource.volume_template
          @item.set_storage_volume_template(resource_named(:VolumeTemplate).new(@item.client, name: @new_resource.volume_template))
        else # Can't set the storage_pool or snapshot_pool if we specify a volume_template
          validate_required_properties(:storage_system, :storage_pool)
          storage_system = resource_named(:StorageSystem).new(@item.client, credentials: { ip_hostname: @new_resource.storage_system }, name: @new_resource.storage_system)
          @item.set_storage_system(storage_system)
          @item.set_storage_pool(resource_named(:StoragePool).new(@item.client, name: @new_resource.storage_pool, storageSystemUri: storage_system['uri']))
          @item.set_snapshot_pool(resource_named(:StoragePool).new(@item.client, name: @new_resource.snapshot_pool, storageSystemUri: storage_system['uri'])) if @new_resource.snapshot_pool
        end

        # Convert capacity integers to strings
        @item['provisionedCapacity'] = @item['provisionedCapacity'].to_s if @item['provisionedCapacity']
        @item['allocatedCapacity'] = @item['allocatedCapacity'].to_s if @item['allocatedCapacity']

        set_provisioning_parameters unless @item.exists? # Also set provisioningParameters if the volume does not exist
      end

      def set_provisioning_parameters
        @item['provisioningParameters'] ||= {}
        shareable = !@item['shareable'].nil? && @item['provisioningParameters']['shareable'].nil?
        @item['provisioningParameters']['shareable'] = @item['shareable'] if shareable
        @item['provisioningParameters']['provisionType'] ||= @item['provisionType'] if @item['provisionType']
        @item['provisioningParameters']['requestedCapacity'] ||= @item['provisionedCapacity'] if @item['provisionedCapacity']
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
        raise "UnspecifiedProperty: 'snapshot_data'. Please set it before attempting this action." unless @new_resource.snapshot_data
        temp = convert_keys(Marshal.load(Marshal.dump(@new_resource.snapshot_data)), :to_s)
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        snapshot = @item.get_snapshot(temp['name'])
        return Chef::Log.info "Volume snapshot '#{temp['name']}' already exists" if snapshot
        Chef::Log.info "Creating oneview_volume '#{@name}' snapshot"
        @context.converge_by "Created oneview_volume '#{@name}' snapshot" do
          @item.create_snapshot(temp)
        end
      end

      def delete_snapshot
        raise "UnspecifiedProperty: 'snapshot_data'. Please set it before attempting this action." unless @new_resource.snapshot_data
        temp = convert_keys(Marshal.load(Marshal.dump(@new_resource.snapshot_data)), :to_s)
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
