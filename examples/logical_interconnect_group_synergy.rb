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

# NOTE: The api_version client should be 300 or greater if you run the examples using Scopes

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 300
}

# ICM (Interconnect Module) types
icm_type_1 = 'Virtual Connect SE 40Gb F8 Module for Synergy'
icm_type_2 = 'Synergy 20Gb Interconnect Link Module'

# DATA FOR THE FIRST UPLINK SET
connections_01 = [
  { bay: 3, port: 'Q1', type: icm_type_1, enclosure_index: 1 },
  { bay: 6, port: 'Q1', type: icm_type_1, enclosure_index: 2 }
]
lig_01_uplink_01_data = {
  name: 'LogicalInterconnectGroup1 - UplinkSet1',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged'
}
networks_01 = ['EthernetNetwork1','EthernetNetwork2']

# DATA FOR THE SECOND UPLINK SET
connections_02 = [
  { bay: 3, port: 'Q2:1', type: icm_type_1, enclosure_index: 1 },
  { bay: 3, port: 'Q2:2', type: icm_type_1, enclosure_index: 1 }
]
lig_01_uplink_02_data = {
  name: 'LogicalInterconnectGroup3 - UplinkSet2',
  networkType: 'FibreChannel'
}
networks_02 = ['FCNetwork1']

# Logical Interconnect Group 1
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  api_variant 'Synergy'
  data(
     redundancyType: 'HighlyAvailable',
     interconnectBaySet: 3,
     enclosureIndexes: [1, 2],
     enclosureType: 'SY12000'
  )
  interconnects [
    { bay: 3, type: icm_type_1, enclosure_index: 1 },
    { bay: 6, type: icm_type_2, enclosure_index: 1 },
    { bay: 3, type: icm_type_2, enclosure_index: 2 },
    { bay: 6, type: icm_type_1, enclosure_index: 2 }
  ]
  uplink_sets [
    { data: lig_01_uplink_01_data, connections: connections_01, networks: networks_01 },
    { data: lig_01_uplink_02_data, connections: connections_02, networks: networks_02 }
  ]
end
################################

# Adds 'LogicalInterconnectGroup1' to 'Scope1' and 'Scope2'
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  api_variant 'Synergy'
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
end

# Removes 'LogicalInterconnectGroup1' from 'Scope1'
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  api_variant 'Synergy'
  scopes ['Scope1']
  action :remove_from_scopes
end

# Replaces scopes to 'Scope1' and 'Scope2'
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  api_variant 'Synergy'
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
end

# Replaces all scopes to empty list of scopes
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  api_variant 'Synergy'
  operation 'replace'
  path '/scopeUris'
  value []
  action :patch
end


# CLEANING UP THE LOGICAL INTERCONNECT GROUPS #
oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client my_client
  api_variant 'Synergy'
  action :delete
end
