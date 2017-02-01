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

# Example: No action is executed.
# In a resource that has only one action and no action is specified in the block
# Chef executes this one. To prevent Chef from removing a switch as the standard action we created
# the none action
oneview_switch 'Switch1' do
  client my_client
end

# Example: Replace the Scopes for the Switch with a patch.
oneview_switch 'Switch1' do
  client my_client
  api_version 300
  api_variant 'C7000'
  operation 'replace'
  path '/scopeUris'
  value '/rest/scopes/3b292baf-8b59-4671-9e5c-deca07496c60'
  action :patch
end

# Example: Removes the Switch
oneview_switch 'Switch1' do
  client my_client
  action :remove
end
