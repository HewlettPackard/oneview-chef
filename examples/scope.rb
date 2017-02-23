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

# NOTE: Support only in API300 onwards.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 300
}

# Example: Create a Scope with a simple description
oneview_scope 'Scope1' do
  client my_client
  api_version 300
  data(
    description: 'Sample Scope description'
  )
end

# Example: Add an Enclosure and a ServerHardware to the scope
# previously created
oneview_scope 'Scope1' do
  client my_client
  api_version 300
  add(
    Enclosure: ['Encl1'],
    ServerHardware: ['Server1']
  )
  action :change_resource_assignments
end

# Example: Add a different Enclosure and ServerHardware to the scope
# previously created, while removing the first Enclosure and Server Hardware
oneview_scope 'Scope1' do
  client my_client
  api_version 300
  add(
    Enclosure: ['Encl2'],
    ServerHardware: ['Server2']
  )
  remove(
    Enclosure: ['Encl1'],
    ServerHardware: ['Server1']
  )
  action :change_resource_assignments
end

# Example: Remove the second Enclosure added to the scope
oneview_scope 'Scope1' do
  client my_client
  api_version 300
  remove(
    Enclosure: ['Encl2'],
  )
  action :change_resource_assignments
end

# Example: Delete the Scope created in this example
oneview_scope 'Scope1' do
  client my_client
  api_version 300
  action :delete
end
