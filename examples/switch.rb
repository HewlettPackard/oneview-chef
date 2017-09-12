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
# NOTE 2: The api_version client should be 300 or greater if you run the examples using Scopes

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 300
}

# Example: No action is executed.
# In a resource that only has destructive and non intuitive actions, Chef executes the none action to avoid mistakes.
# To prevent Chef from removing a switch or using a non intuitive action as the standard action, we created the none action.
oneview_switch 'Switch1' do
  client my_client
end

# Example: Adds 'Switch1' to 'Scope1' and 'Scope2'
oneview_switch 'Switch1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
end

# Example: Removes 'Switch1' from 'Scope1'
oneview_switch 'Switch1' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
end

# Example: Replaces 'Scope1' and 'Scope2' for 'Switch1'
oneview_switch 'Switch1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
end

# Example: Replaces all scopes to empty list of scopes
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
