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

# NOTE 1: This example requires two Scopes named "Scope1" and "Scope2" to be present in the appliance.
# NOTE 2: The :update_port action is only for ports under the management of OneView and those that are unlinked
#         and is available for 300 or higher api version.
# NOTE 3: The api_version client should be 300 or 500 if you run the examples using Scopes.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 600
}

# Example: No action is executed.
# In a resource that only has destructive and non intuitive actions, Chef executes the none action to avoid mistakes.
# To prevent Chef from removing a switch or using a non intuitive action as the standard action, we created the none action.
oneview_switch 'Switch1' do
  client my_client
end

oneview_switch 'Switch1' do
  client my_client
  api_variant 'C7000'
  api_version 300
  port_options(
    name: '1.1',
    portName: '1.1',
    enabled: true
  )
  action :update_port
end

# Example: Adds 'Switch1' to 'Scope1' and 'Scope2'
# Available only in Api300 and Api500
oneview_switch 'Switch1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
end

# Example: Removes 'Switch1' from 'Scope1'
# Available only in Api300 and Api500
oneview_switch 'Switch1' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
end

# Example: Replaces 'Scope1' and 'Scope2' for 'Switch1'
# Available only in Api300 and Api500
oneview_switch 'Switch1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
end

# Example: Replaces all scopes to empty list of scopes
# Available only in Api300 and Api500
oneview_switch 'Switch1' do
  client my_client
  operation 'replace'
  path '/scopeUris'
  value []
  action :patch
end

# Example: Removes the Switch
oneview_switch 'Switch1' do
  client my_client
  action :remove
end
