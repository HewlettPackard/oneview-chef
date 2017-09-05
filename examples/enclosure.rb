# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE: This recipe requires:
# Enclosure group: Eg1
# Scopes: Scope1, Scope2

# NOTE 2: The api_version client should be 300 or greater if you run the examples using Scopes

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 300
}

oneview_enclosure 'Encl1' do
  data(
    hostname: '172.18.1.11',
    username: 'dcs',
    password: 'dcs',
    licensingIntent: 'OneView'
  )
  enclosure_group 'Eg1'
  client my_client
  action :add
end

# Rename enclosure
# Warning: Operation persists in hardware
oneview_enclosure 'Encl1' do
  client my_client
  operation 'replace'
  path '/name'
  value 'ChefEncl1'
  action :patch
end

# Restoring its original name
oneview_enclosure 'ChefEncl1' do
  client my_client
  operation 'replace'
  path '/name'
  value 'Encl1'
  action :patch
end

# Refreshes the enclosure
oneview_enclosure 'Encl1' do
  client my_client
  action :refresh
end

# Adds 'Encl1' to 'Scope1' and 'Scope2'
oneview_enclosure 'Encl1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
end

# Removes 'Encl1' from 'Scope1'
oneview_enclosure 'Encl1' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
end

# Replaces 'Scope1' and 'Scope2' for 'Encl1'
oneview_enclosure 'Encl1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
end

# Removes it from the appliance
oneview_enclosure 'Encl1' do
  client my_client
  action :remove
end
