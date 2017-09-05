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

# Replace these credentials with your own:
storage_system_credentials = {
  ip_hostname: '',
  username: '',
  password: ''
}

# Example: add storage system or update if it already exists
oneview_storage_system 'StorageSystem1' do
  client my_client
  data(
    credentials: storage_system_credentials,
    managedDomain: 'TestDomain'
  )
  action :add
end

# Example: add storage system if it does not exist
oneview_storage_system 'StorageSystem1' do
  client my_client
  data(
    credentials: storage_system_credentials,
    managedDomain: 'TestDomain'
  )
  action :add_if_missing
end

# Example: edit storage system credentials
oneview_storage_system 'StorageSystem1' do
  client my_client
  data(
    ip_hostname: '127.0.0.1',
    username: 'username',
    password: 'password'
  )
  action :edit_credentials
end

# Example: refresh storage system
oneview_storage_system 'StorageSystem1' do
  client my_client
  action :refresh
end

# Example: remove storage system
oneview_storage_system 'StorageSystem1' do
  client my_client
  action :remove
end
