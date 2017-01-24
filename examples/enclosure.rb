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

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
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

# Removes it from the appliance
oneview_enclosure 'Encl1' do
  client my_client
  action :remove
end
