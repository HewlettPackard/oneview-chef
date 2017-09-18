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

# NOTE: This recipe requires one Storage System with IP '172.18.11.11'
# and one Storage Pool named 'CPG-SSD' associated to this Storage System

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 500
}

properties = {
  provisioningType: {
    type: 'string',
    required: true,
    enum: [
      'Thin',
      'Full'
    ],
    default: 'Full'
  },
  isShareable: {
    type: 'boolean',
    default: true,
    meta: {
      locked: true
    }
  },
  size: {
    type: 'integer',
    minimum: 1024 * 1024 * 1024 # 1GB
  }
}

# Example: create or update a volume template, specifying a storage system hostname/IP
oneview_volume_template 'VolumeTemplate1' do
  client my_client
  data(
    description: 'VolumeTemplate1 description',
    properties: properties
  )
  storage_system '172.18.11.11'
  storage_pool 'CPG-SSD'
end

# Example: creates or updates a volume template, specifying a storage system name
oneview_volume_template 'VolumeTemplate2' do
  client my_client
  data(
    description: 'VolumeTemplate2 description',
    properties: properties
  )
  storage_system 'ThreePAR-1'
  storage_pool 'CPG-SSD'
end

# Example: create a volume template only if does not exists (no updates)
oneview_volume_template 'VolumeTemplate3' do
  client my_client
  data(
    description: 'VolumeTemplate3 description',
    properties: properties
  )
  storage_system '172.18.11.11'
  storage_pool 'CPG-SSD'
  action :create_if_missing
end

# Example: updates a volume template
oneview_volume_template 'VolumeTemplate1' do
  client my_client
  storage_system '172.18.11.11'
  storage_pool 'CPG-SSD'
  snapshot_pool 'CPG-SSD'
end

# Example: delete a volume template
oneview_volume_template 'VolumeTemplate1' do
  client my_client
  action :delete
end

# Example: delete a volume template
oneview_volume_template 'VolumeTemplate2' do
  client my_client
  action :delete
end

# Example: delete a volume template
oneview_volume_template 'VolumeTemplate3' do
  client my_client
  action :delete
end
