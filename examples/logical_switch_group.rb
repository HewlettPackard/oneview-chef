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

# Ensures the existence of one Logical Switch Group with room for 2 Switches with type 'Cisco Nexus 50xx'
oneview_logical_switch_group 'LogicalSwitchGroup1' do
  client my_client
  switch_number 2
  switch_type 'Cisco Nexus 50xx'
end

# Creates LogicalSwitchGroup2 only if no Logical Switch group already created with that name
oneview_logical_switch_group 'LogicalSwitchGroup2' do
  client my_client
  switch_number 1
  switch_type 'Cisco Nexus 50xx'
  action :create_if_missing
end

# Example: Add the Scope with URI /rest/scopes/7887dc77-c4b7-474a-9b9e-b7cba3d11d93 to LogicalSwitchGroup1
oneview_logical_switch_group 'LogicalSwitchGroup3' do
  client my_client
  data(name: 'LogicalSwitchGroup1')
  operation 'add'
  path '/scopeUris/-'
  value '/rest/scopes/7887dc77-c4b7-474a-9b9e-b7cba3d11d93'
  action :patch
end

# Deletes the logical switches groups:
# Delete action will only need the name and client
(1..2).each do |i|
  oneview_logical_switch_group "Delete LogicalSwitchGroup#{i}" do
    client my_client
    data(name: "LogicalSwitchGroup#{i}")
    action :delete
  end
end
