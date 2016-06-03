################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

# NOTE: This recipe requires:
# Ethernet Networks: CHEF_ETH_NETWORK_01, CHEF_ETH_NETWORK_02
# FC Network: CHEF_FC_NETWORK_01


my_client = {
  url: 'https://XXX.XXX.XXX.XXX/',
  user: 'USR',
  password: 'PWD',
  ssl_enabled: false
}

# Simple Logical Interconnect group creation without interconnects and uplinks
lig_data = {
  enclosureType: 'C7000',
  type: 'logical-interconnect-groupV3'
}

oneview_logical_interconnect_group 'CHEF_LIG_01' do
  client my_client
  data lig_data
  action :create
end

# Logical Interconnect group creation with interconnects but without uplinks
oneview_logical_interconnect_group 'CHEF_LIG_02' do
  client my_client
  data lig_data
  interconnects [
    {bay: 1, type: 'HP VC FlexFabric 10Gb/24-Port Module'},
    {bay: 2, type: 'HP VC FlexFabric 10Gb/24-Port Module'}
  ]
  action :create
end


# Complete Logical Interconnect group creation with interconnects and uplinks
lig_03_uplink_01_data = {
  name: 'CHEF_LIG_03_UPLINK_SET_01',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged'
}

connections_01 = [
    {bay: 1, port: 'X5'},
    {bay: 1, port: 'X6'},
    {bay: 2, port: 'X7'},
    {bay: 2, port: 'X8'}
]

networks_01 = ['CHEF_ETH_NETWORK_01','CHEF_ETH_NETWORK_02']

lig_03_uplink_02_data = {
  name: 'CHEF_LIG_03_UPLINK_SET_02',
  networkType: 'FibreChannel'
}

connections_02 = [
    {bay: 1, port: 'X1'},
    {bay: 1, port: 'X2'}
]

networks_02 = ['CHEF_FC_NETWORK_01']

oneview_logical_interconnect_group 'CHEF_LIG_03' do
  client my_client
  data lig_data
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


oneview_logical_interconnect_group 'CHEF_LIG_01' do
  client my_client
  data ({})
  action :delete
end

oneview_logical_interconnect_group 'CHEF_LIG_02' do
  client my_client
  data ({})
  action :delete
end

oneview_logical_interconnect_group 'CHEF_LIG_03' do
  client my_client
  data ({})
  action :delete
end
