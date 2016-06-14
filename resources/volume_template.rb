# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

Opscode::OneviewResourceBaseProperties.load(self)

property :storage_system_ip, [String]
property :storage_system_name, [String]
property :storage_pool, [String]
property :snapshot_pool, [String]

default_action :create

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase

  # Loads the Volume with all the external resources (if needed)
  # @return [OneviewSDK::Volume] Loaded Volume resource
  def load_resource_with_associated_resources
    item = load_resource
    item = load_storage_system(item)

    # item.set_storage_pool(OneviewSDK::StoragePool.new(item.client, name: storage_pool)) if storage_pool
    # HACK Ruby SDK 1.0.0 issue workaround
    sp = OneviewSDK::StoragePool.new(item.client, name: storage_pool)
    raise "Storage Pool '#{sp['name']}' not found" unless sp.retrieve!
    item['provisioning']['storagePoolUri'] = sp['uri']

    item.set_snapshot_pool(OneviewSDK::StoragePool.new(item.client, name: snapshot_pool)) if snapshot_pool
    item
  end

  # Loads Storage System in the given Volume resource.
  # The properties storage_system_name or storage_system_ip properties needs to be used in the recipe
  #  for this code to load the Storage System.
  # The storage_system_ip property has priority above the others
  # @param [OneviewSDK::Volume] item Volume to add the Storage System
  # @return [OneviewSDK::Volume] Volume with Storage System parameters updated
  def load_storage_system(item)
    warn_msg = "Both Storage System Name '#{storage_system_name}' and IP '#{storage_system_ip}' were provided. Name is being ignored!"
    Chef::Log.warn(warn_msg) if storage_system_name & storage_system_ip
    item.set_storage_system(OneviewSDK::StorageSystem.new(item.client, name: storage_system_name)) if storage_system_name && !storage_system_ip
    item.set_storage_system(OneviewSDK::StorageSystem.new(item.client, credentials: { ip_hostname: storage_system_ip })) if storage_system_ip
    item
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
