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

node.default['oneview']['api_version'] = 500

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 500
}

# Example: add storage system or update if it already exists
oneview_storage_system 'ThreePAR-1' do
  client my_client
  data(
    credentials: {
      username: @storage_system_username,
      password: @storage_system_password
    },
    hostname: @storage_system_ip,
    family: 'StoreServ',
    deviceSpecificAttributes: {
      managedDomain: 'TestDomain'
    }
  )
  action :add
end

# Example: Refresh storage system using its hostname
oneview_storage_system 'ThreePAR-1' do
  client my_client
  data(
    hostname: '172.18.11.11'
  )
  action :refresh
end


# Example: remove storage system
oneview_storage_system 'ThreePAR-1' do
  client my_client
  action :remove
end
