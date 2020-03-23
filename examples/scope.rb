# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE: Support only in API600 onwards.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 600
}

# Example: Create a Scope with a simple description
oneview_scope 'Scope1' do
  client my_client
  data(
    description: 'Sample Scope1 description'
  )
end

# Example: Create another Scope with a simple description
oneview_scope 'Scope2' do
  client my_client
  data(
    description: 'Sample Scope2 description'
  )
end

# Example: Add an Enclosure and a ServerHardware to the scope
# previously created
oneview_scope 'Scope1' do
  client my_client
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
  remove(
    Enclosure: ['Encl2'],
  )
  action :change_resource_assignments
end

# Example: Replace a resource scope with a list of scopes
# and is available for API600 or greater
oneview_scope 'replace resource scopes assignments' do
  client my_client
  api_variant 'Synergy'
  replace(
    Enclosure: ['0000A66101']
  )
  scopes ['Scope2']
  action :replace_resource_scopes_assignments
end

# Example: Add a scope and remove scope which was previously added to resource
# and is available for API600 or greater
oneview_scope 'modify resource scopes assignments' do
  client my_client
  api_variant 'Synergy'
  add(
    Scope: ['Scope2']
  )
  remove(
    Scope: ['Scope1']
  )
  resource(
    ServerHardware: ['0000A66101, bay 3']
  )
  action :modify_resource_scopes_assignments
end

# Example: Remove scope which was previously added to resource
# and is available for API600 or greater
oneview_scope 'modify resource scopes assignments' do
  client my_client
  api_variant 'Synergy'
  remove(
    Scope: ['Scope2']
  )
  resource(
    ServerHardware: ['0000A66101, bay 3']
  )
  action :modify_resource_scopes_assignments
end

# Example: Add a scope to a resource and is available
# for API600 or greater
oneview_scope 'modify resource scopes assignments' do
  client my_client
  api_variant 'Synergy'
  add(
    Scope: ['Scope2']
  )
  resource(
    Enclosure: ['0000A66101']
  )
  action :modify_resource_scopes_assignments
end

# Example: Delete the Scope created in this example
oneview_scope 'Scope1' do
  client my_client
  action :delete
end
