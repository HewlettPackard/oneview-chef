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

# Load credentials to use in the switches in the Logical Switch
# WARNING: The credentials are explicit only for demonstration purposes
# It's highly recommended to store them in a databag, restricted file or even the client
ssh_credentials_1 = {user: 'usr', password: 'pwd'}
ssh_credentials_2 = {user: 'usr', password: 'pwd'}
default_snmpv1_credentials = {port: 161, community_string: 'public'}

# Create or update a Logical Switch named LogicalSwitch1 based on the LogicalSwitchGroup1
# The number of credentials must be equal the number of switches the group supports
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  logical_switch_group 'LogicalSwitchGroup1'
  credentials([
    { host: '172.xx.xx.1', ssh_credentials: ssh_credentials_1, snmp_credentials: default_snmpv1_credentials },
    { host: '172.xx.xx.2', ssh_credentials: ssh_credentials_2, snmp_credentials: default_snmpv1_credentials }
  ])
end

# Creates a Logical Switch named LogicalSwitch1 based on the LogicalSwitchGroup1 only if it does not exists
# The number of credentials must be equal the number of switches the group supports
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  logical_switch_group 'LogicalSwitchGroup1'
  credentials([
    { host: '172.xx.xx.1', ssh_credentials: ssh_credentials_1, snmp_credentials: default_snmpv1_credentials },
    { host: '172.xx.xx.2', ssh_credentials: ssh_credentials_2, snmp_credentials: default_snmpv1_credentials }
  ])
  action :create_if_missing
end

# Refreshes the LogicalSwitch1
# This action reclaims the top-of-rack switches associated with the Logical Switch
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  action :refresh
end

# Example: Adds 'LogicalSwitch1' to 'Scope1' and 'Scope2'
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
end

# Example: Removes 'LogicalSwitch1' from 'Scope1'
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
end

# Example: Replaces 'Scope1' and 'Scope2' for 'LogicalSwitch1'
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
end

# Example: Replaces all scopes to empty list of scopes
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  operation 'replace'
  path '/scopeUris'
  value []
  action :patch
end

# Removes the LogicalSwitch1 and all of its associated Switches
oneview_logical_switch 'LogicalSwitch1' do
  client my_client
  action :delete
end
