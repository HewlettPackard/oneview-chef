# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

OneviewCookbook::ResourceBaseProperties.load(self)

property :storage_system, String
property :storage_pool, String
property :volume_template, String
property :snapshot_pool, String
property :snapshot_data, Hash

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase

  # Loads the Volume with all the external resources (if needed)
  # @return [OneviewSDK::Volume] Loaded Volume resource
  # rubocop:disable Metrics/MethodLength
  def load_resource_with_associated_resources
    item = load_resource
    if volume_template
      item.set_storage_volume_template(OneviewSDK::VolumeTemplate.new(item.client, name: volume_template))
    else # Can't set the storage_pool or snapshot_pool if we specify a volume_template
      load_storage_system(item) if storage_system

      # item.set_storage_pool(OneviewSDK::StoragePool.new(item.client, name: storage_pool)) if storage_pool
      # Workaround for issue in oneview-sdk:
      if storage_pool
        raise 'Must specify a storage_system to use the storage_pool helper.' unless item['storageSystemUri']
        sp = OneviewSDK::StoragePool.find_by(item.client, name: storage_pool, storageSystemUri: item['storageSystemUri']).first
        raise "Storage Pool '#{sp['name']}' not found" unless sp
        item['storagePoolUri'] = sp['uri']
      end

      if snapshot_pool
        raise 'Must specify a storage_system to use the storage_pool helper.' unless item['storageSystemUri']
        snapshot_pool_resource = OneviewSDK::StoragePool.find_by(item.client, name: snapshot_pool, storageSystemUri: item['storageSystemUri']).first
        item.set_snapshot_pool(snapshot_pool_resource)
      end
    end

    # Convert capacity integers to strings
    item['provisionedCapacity'] = item['provisionedCapacity'].to_s if item['provisionedCapacity']
    item['allocatedCapacity'] = item['allocatedCapacity'].to_s if item['allocatedCapacity']

    unless item.exists? # Also set provisioningParameters if the volume does not exist
      item['provisioningParameters'] ||= {}
      item['provisioningParameters']['shareable'] = item['shareable'] if !item['shareable'].nil? && item['provisioningParameters']['shareable'].nil?
      item['provisioningParameters']['provisionType'] ||= item['provisionType'] if item['provisionType']
      item['provisioningParameters']['requestedCapacity'] ||= item['provisionedCapacity'] if item['provisionedCapacity']
      item['provisioningParameters']['storagePoolUri'] ||= item['storagePoolUri'] if item['storagePoolUri']
      item.data.delete('provisioningParameters') if item['provisioningParameters'].empty?
    end
    item
  end
  # rubocop:enable Metrics/MethodLength

  # Loads Storage System into the given Volume resource.
  # The storage_system property needs to be set to a name or IP in order to use this method
  # @param [OneviewSDK::Volume] item Volume to add the Storage System
  # @return [OneviewSDK::Volume] Volume with Storage System parameters updated
  def load_storage_system(item)
    storage_system_resource = OneviewSDK::StorageSystem.new(item.client, credentials: { ip_hostname: storage_system })
    unless storage_system_resource.exists?
      storage_system_resource = OneviewSDK::StorageSystem.new(item.client, name: storage_system)
    end
    item.set_storage_system(storage_system_resource)
  end
end

action :create do
  create_or_update(load_resource_with_associated_resources)
end

action :create_if_missing do
  create_if_missing(load_resource_with_associated_resources)
end

action :delete do
  delete
end

action :create_snapshot do
  item = load_resource
  raise "Unspecified property: 'snapshot_data'. Please set it before attempting this action." unless snapshot_data
  raise "Resource not found: #{resource_name} '#{item['name']}'" unless item.exists?

  temp = convert_keys(snapshot_data, :to_s)
  item.retrieve!
  snapshot = item.get_snapshot(temp['name'])
  if snapshot.empty?
    Chef::Log.info "Creating oneview_volume '#{name}' snapshot"
    converge_by "Created oneview_volume '#{name}' snapshot" do
      item.create_snapshot(temp)
    end
  else
    Chef::Log.info "Volume snapshot '#{temp['name']}' already exists"
  end
end

action :delete_snapshot do
  item = load_resource
  raise "Unspecified property: 'snapshot_data'. Please set it before attempting this action." unless snapshot_data
  raise "Resource not found: #{resource_name} '#{item['name']}'" unless item.exists?

  temp = convert_keys(Marshal.load(Marshal.dump(snapshot_data)), :to_s)
  item.retrieve!
  snapshot = item.get_snapshot(temp['name'])
  if snapshot.empty?
    Chef::Log.info "Volume snapshot '#{temp['name']}' is already deleted"
  else
    Chef::Log.info "Deleting oneview_volume '#{name}'"
    converge_by "Deleted oneview_volume_snapshot '#{name}'" do
      item.delete_snapshot(temp['name'])
    end
  end
end
