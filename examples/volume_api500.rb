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

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 500
}

store_serv_properties = {
  description: 'Volume store serv',
  isShareable: true,
  provisioningType: 'Thin',
  size: 1024 * 1024 * 1024 # 1GB
}

store_virtual_properties = {
  description: 'Volume store virtual',
  isShareable: true,
  provisioningType: 'Thin',
  size: 1024 * 1024 * 1024, # 1GB
  dataProtectionLevel: 'NetworkRaid10Mirror2Way'
}

# Example: Create a simple store serv volume
oneview_volume 'CHEF_VOL_01' do
  client my_client
  data(store_serv_properties)
  storage_pool 'CPG-SSD-AO'
  storage_system 'ThreePAR-1'
end

# Example: Update a volume
oneview_volume 'CHEF_VOL_01' do
  client my_client
  data(description: 'Volume store serv Updated')
  storage_pool 'CPG-SSD-AO'
  storage_system 'ThreePAR-1'
end

# Example: Create a store serv volume from a volume template
oneview_volume 'CHEF_VOL_02' do
  client my_client
  data(store_serv_properties)
  volume_template 'VolumeTemplate_1'
end

# Example: Create a store serv volume with snapshot pool specified
oneview_volume 'CHEF_VOL_03' do
  client my_client
  data(store_serv_properties)
  storage_pool 'CPG-SSD-AO'
  snapshot_pool 'CPG-SSD-AO'
  storage_system 'ThreePAR-1'
end

# Example: Create a simple store virtual volume
oneview_volume 'CHEF_VIRTUAL_VOL_01' do
  client my_client
  data(store_virtual_properties)
  storage_system 'Cluster-1'
  storage_pool 'Cluster-1'
end

# Example: Create a store virtual volume from a volume template
oneview_volume 'CHEF_VIRTUAL_VOL_02' do
  client my_client
  data(store_virtual_properties)
  volume_template 'VolumeTemplateVirtual_1'
end

# Example: Create a snapshot from the volume created by this recipe
oneview_volume 'CHEF_VOL_03' do
  client my_client
  snapshot_data(
    name: 'CHEF_VOL_SNAP_01',
    description: 'Volume snapshot'
  )
  action :create_snapshot
end

# Example: Create a volume from snapshot
oneview_volume 'CHEF_VOL_03' do
  client my_client
  properties(
    name: 'CHEF_VOL_04',
    snapshotName: 'CHEF_VOL_SNAP_01',
    description: 'Volume store serv',
    isShareable: true,
    provisioningType: 'Thin',
    size: 1024 * 1024 * 1024 # 1GB
  )
  action :create_from_snapshot
end

# Example: Create a volume from snapshot and a specific volume template
oneview_volume 'CHEF_VOL_03' do
  client my_client
  properties(
    name: 'CHEF_VOL_05',
    snapshotName: 'CHEF_VOL_SNAP_01',
    description: 'Volume store serv',
    isShareable: true,
    provisioningType: 'Thin',
    size: 1024 * 1024 * 1024 # 1GB
  )
  volume_template 'VolumeTemplate_1'
  action :create_from_snapshot
end

# Example: Delete a volume from appliance only
oneview_volume 'CHEF_VOL_01' do
  client my_client
  delete_from_appliance_only true
  action :delete
end

# Example: Add a volume (created external to OneView) for management by the appliance
oneview_volume 'CHEF_VOL_01' do
  client my_client
  data(
    description: 'Volume added',
    isShareable: false
  )
  storage_system 'ThreePAR-1'
  action :add_if_missing
end

# Example: Delete a volume snapshot
oneview_volume 'CHEF_VOL_03' do
  client my_client
  snapshot_data(
    name: 'CHEF_VOL_SNAP_01'
  )
  action :delete_snapshot
end

# Deletes the storeserv volumes from aplliance and storage system:
# Delete action will only need the name and client
(1..5).each do |i|
  oneview_volume "CHEF_VOL_0#{i}" do
    client my_client
    action :delete
  end
end

# Deletes the storevirtual volumes from aplliance and storage system:
# Delete action will only need the name and client
(1..2).each do |i|
  oneview_volume "CHEF_VIRTUAL_VOL_0#{i}" do
    client my_client
    action :delete
  end
end
