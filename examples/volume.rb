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

my_client = {
  url: '',
  user: '',
  password: ''
}

# Example: Create a volume
# In this example, we'll set all the data necessary to create a new volume from scratch.
# You'll notice that in the OneView API docs, there is a "provisioningParameters" hash that defines
# most of the data for creating new volumes, but when you retrieve or update them, that hash is
# gone (and everything has moved to the top level). This model is a little confusing, so we've made
# it a little easier. All you have to do is define the data attributes like you would for an update,
# and and the oneview_volume resource automatically populates the provisioningParameters hash for you.
# This resource also provides some helpful properties that automatically retrieve URIs for the
# StorageSystem, StoragePool, VolumeTemplate, and SnapshotPool; all you have to do is specify the name.
oneview_volume 'CHEF_VOL_01' do
  client my_client
  data(
    description: 'Created by Chef',
    shareable: true,
    provisionType: 'Thin', # Or 'Full'
    provisionedCapacity: 1024 * 1024 * 1024 # 1GB
  )
  storage_system_name 'ThreePAR7200-3167' # Name of the storage system
  storage_pool 'CPG_FC-AO' # Name of the storage pool
  snapshot_pool 'CPG_FC-AO' # Name of the storage pool used for snapshots
end


# Example: Create a volume (using the storage system IP)
# This example is identical to the one above, except we use the "storage_system_ip" property instead
# of the "storage_system_name". You can use either one, but if you provide both, only the IP will be
# used.
oneview_volume 'CHEF_VOL_02' do
  client my_client
  data(
    description: 'Created by Chef',
    shareable: true,
    provisionType: 'Thin', # Or 'Full'
    provisionedCapacity: 1024 * 1024 * 1024 # 1GB
  )
  storage_system_ip '172.18.11.11' # IP of the storage system
  storage_pool 'CPG_FC-AO' # Name of the storage pool
  snapshot_pool 'CPG_FC-AO' # Name of the storage pool used for snapshots
end


# Example: Create a volume using a VolumeTemplate
# VolumeTemplates are very helpful when you want to (mostly) the same settings for multiple volumes.
# We can override all the template options, but you really only need to provide the capacity.
oneview_volume 'CHEF_VOL_03' do
  client my_client
  data(
    description: 'Created by Chef using template',
    provisionedCapacity: 1024 * 1024 * 1024 * 2 # 2GB
  )
  volume_template 'Template1' # Name of the VolumeTemplate
end

# Example: Make sure a volume does not exist
oneview_volume 'CHEF_VOL_04' do
  client my_client
  action :delete
end
