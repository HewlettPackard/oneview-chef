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
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# Example: Adds storage pool if it is not added in HPE OneView using
# the storage system name
oneview_storage_pool 'CPG_FC-AO' do
  client my_client
  storage_system 'ThreePAR7200-8147'
end

# Example: Adds storage pool if it is not added in HPE OneView using
# the storage system hostname
oneview_storage_pool 'CPG_FC-AO' do
  client my_client
  storage_system '172.XX.XX.XX'
end

# Example: Removes storage pool from HPE OneView
oneview_storage_pool 'CPG_FC-AO' do
  client my_client
  storage_system '172.XX.XX.XX'
  action :remove
end
