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

# NOTE 1: This example requires two Scopes named "Scope1" and "Scope2" to be present in the appliance.
# NOTE 2: The api_version client should be 300 or greater if you run the examples using Scopes

OneviewCookbook::Helper.load_sdk(self)

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 2200
}

# Example: Create and manage a new ethernet network
oneview_ethernet_network 'Eth1' do
  client my_client
  data(
    vlanId: 1001,
    purpose: 'General',
    smartLink: false,
    privateNetwork: false
  )
end

# Example: Create a new ethernet network only if it doesn't exist.
# No updates will be made if the network exists but attributes differ
oneview_ethernet_network 'Eth1' do
  client my_client
  data(
    vlanId: 1001,
    purpose: 'General',
    smartLink: false,
    privateNetwork: false,
    bandwidth: {
      typicalBandwidth: 2000,
      maximumBandwidth: 9000
    }
  )
  action :create_if_missing
end

# Only for API1800 or greater
# Example: Bulk deletes ethernet networks.
oneview_ethernet_network 'None' do
  client my_client
  test1 = OneviewCookbook::Helper.load_resource(my_client, type: 'EthernetNetwork', id: 'Test1')
  test2 = OneviewCookbook::Helper.load_resource(my_client, type: 'EthernetNetwork', id: 'Test2')
  data(
     networkUris: [ test1['uri'], test2['uri'] ]
  )
  action :delete_bulk
  only_if { client[:api_version] >= 1800 }
end

# Only for V300 and V500
# Example: Adds 'Eth1' to 'Scope1' and 'Scope2'
oneview_ethernet_network 'Eth1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Only for V300 and V500
# Example: Removes 'Eth1' from 'Scope1'
oneview_ethernet_network 'Eth1' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Only for V300 and V500
# Example: Replaces 'Scope1' and 'Scope2' for 'Eth1'
oneview_ethernet_network 'Eth1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Only for V300 and V500
# Example: Replaces all scopes to empty list of scopes
oneview_ethernet_network 'Eth1' do
  client my_client
  operation 'replace'
  path '/scopeUris'
  value []
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
  action :patch
end

# Example: Reset the connection template for a network
oneview_ethernet_network 'Eth1' do
  client my_client
  action :reset_connection_template
end

# Example: Delete an ethernet network
oneview_ethernet_network 'Eth1' do
  client my_client
  action :delete
end
