# (c) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

node.default['oneview']['api_version'] = 2600

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 2600
}

# Ensures the Storage Pool is managed by the HPE OneView appliance
oneview_storage_pool 'CPG-SSD' do
  client my_client
  storage_system '<storage_system>'
  action :add_for_management
end

# Updates the storage pool description
oneview_storage_pool 'CPG-SSD' do
  client my_client
  storage_system '<storage_system>'
  data(
    description: "SSD Storage pool - CHEF",
    isManaged: false,
    type: ''
  )
  action :update
end

# Refreshes the storage pool
oneview_storage_pool 'CPG-SSD' do
  client my_client
  storage_system '<storage_system>'
  action :refresh
end

# Ensures the Storage Pool is not managed by the HPE OneView appliance i.e. it is only discovered
oneview_storage_pool 'CPG-SSD' do
  client my_client
  storage_system '<storage_system>'
  action :remove_from_management
end
