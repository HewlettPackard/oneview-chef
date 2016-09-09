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


client = {
  url: '',
  user: '',
  password: ''
}

# Simple Logical Interconnect group creation without interconnects and uplinks
lig_data = {
  enclosureType: 'C7000',
}

oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client client
  data(enclosureType: 'C7000')
  action :create
end

# Logical Interconnect group creation with interconnects but without uplinks
oneview_logical_interconnect_group 'LogicalInterconnectGroup2' do
  client client
  data(enclosureType: 'C7000')
  interconnects [
    {bay: 1, type: 'HP VC FlexFabric 10Gb/24-Port Module'},
    {bay: 2, type: 'HP VC FlexFabric 10Gb/24-Port Module'}
  ]
  action :create
end


# Complete Logical Interconnect group creation with interconnects and uplinks

# Ethernet uplink set
lig_03_uplink_01_data = {
  name: 'LogicalInterconnectGroup3 - UplinkSet1',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged'
}
connections_01 = [
  {bay: 1, port: 'X5'},
  {bay: 1, port: 'X6'},
  {bay: 2, port: 'X7'},
  {bay: 2, port: 'X8'}
]
networks_01 = ['EthernetNetwork1','EthernetNetwork2']

# Fibre channel uplink set
lig_03_uplink_02_data = {
  name: 'LogicalInterconnectGroup3 - UplinkSet2',
  networkType: 'FibreChannel'
}
connections_02 = [
  {bay: 1, port: 'X1'},
  {bay: 1, port: 'X2'}
]
networks_02 = ['FCNetwork1']

oneview_logical_interconnect_group 'LogicalInterconnectGroup3' do
  client client
  data(enclosureType: 'C7000')
  interconnects [
    {bay: 1, type: 'HP VC FlexFabric 10Gb/24-Port Module'},
    {bay: 2, type: 'HP VC FlexFabric 10Gb/24-Port Module'}
  ]
  uplink_sets [
    { data: lig_03_uplink_01_data,  connections: connections_01, networks: networks_01},
    { data: lig_03_uplink_02_data,  connections: connections_02, networks: networks_02}
  ]
  action :create
end


oneview_logical_interconnect_group 'LogicalInterconnectGroup1' do
  client client
  action :delete
end

oneview_logical_interconnect_group 'LogicalInterconnectGroup2' do
  client client
  action :delete
end

oneview_logical_interconnect_group 'LogicalInterconnectGroup3' do
  client client
  action :delete
end
