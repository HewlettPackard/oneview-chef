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

# NOTE: This recipe requires:
# Ethernet Networks: EthernetNetwork1, EthernetNetwork2
# FC Network: FCNetwork1
# Scopes: Scope1, Scope2

# NOTE 2: The api_version client should be 300 or greater if you run the examples using Scopes

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 300
}

# LOGICAL INTERCONNECT GROUP 1 #
# Simple Logical Interconnect group creation without interconnects and uplinks
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  data(enclosureType: 'C7000')
end
################################


# LOGICAL INTERCONNECT GROUP 2 #
# Logical Interconnect group creation with interconnects but without uplinks
oneview_logical_interconnect_group 'LogicalInterconnectGroup2' do
  client my_client
  data(enclosureType: 'C7000')
  # Define each interconnect type in the corresponding bay
  # If not specified the interconnect is not added to the group
  interconnects [
    { bay: 1, type: 'HP VC FlexFabric 10Gb/24-Port Module' },
    { bay: 2, type: 'HP VC FlexFabric 10Gb/24-Port Module' }
  ]
end
################################


# LOGICAL INTERCONNECT GROUP 3 #
# Complete Logical Interconnect group creation with interconnects and uplinks.
# We are specifying first the Uplink set data outside the chef block to make it more clear.

# Ethernet uplink set
## First specify the main attributes
lig_03_uplink_01_data = {
  name: 'LogicalInterconnectGroup3 - UplinkSet1',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged'
}
## Second, the connections (uplinks)
## Define exactly the ports from the interconnects that need to be linked in this Uplink set
connections_01 = [
  { bay: 1, port: 'X5' },
  { bay: 1, port: 'X6' },
  { bay: 2, port: 'X7' },
  { bay: 2, port: 'X8' }
]
## We finish setting the Uplink set networks (they should be Ethernet networks since it is an Ethernet uplink set)
networks_01 = ['EthernetNetwork1','EthernetNetwork2']

# Now, the Fibre channel uplink set
lig_03_uplink_02_data = {
  name: 'LogicalInterconnectGroup3 - UplinkSet2',
  networkType: 'FibreChannel'
}
connections_02 = [
  { bay: 1, port: 'X1' },
  { bay: 1, port: 'X2' }
]
## Currently, only one FCNetwork is supported per Uplink set
networks_02 = ['FCNetwork1']

## Now, putting everything in the Chef block
oneview_logical_interconnect_group 'LogicalInterconnectGroup3' do
  client my_client
  data(enclosureType: 'C7000')
  interconnects [
    { bay: 1, type: 'HP VC FlexFabric 10Gb/24-Port Module' },
    { bay: 2, type: 'HP VC FlexFabric 10Gb/24-Port Module' }
  ]
  uplink_sets [
    { data: lig_03_uplink_01_data, connections: connections_01, networks: networks_01 },
    { data: lig_03_uplink_02_data, connections: connections_02, networks: networks_02 }
  ]
end
################################

# Adds 'LogicalInterconnectGroup1' to 'Scope1' and 'Scope2'
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
end

# Removes 'LogicalInterconnectGroup1' from 'Scope1'
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
end

# Replaces scopes to 'Scope1' and 'Scope2'
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
end

# Replaces all scopes to empty list of scopes
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  operation 'replace'
  path '/scopeUris'
  value []
  action :patch
end

# CLEANING UP THE LOGICAL INTERCONNECT GROUPS #
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  action :delete
end

oneview_logical_interconnect_group 'LogicalInterconnectGroup2' do
  client my_client
  action :delete
end

oneview_logical_interconnect_group 'LogicalInterconnectGroup3' do
  client my_client
  action :delete
end
