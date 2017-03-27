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

# Ethernet network that will be used for the examples below
oneview_ethernet_network 'ChefEthernet_3001' do
  client my_client
  data(
    vlanId: 3001,
    purpose:  'General',
    smartLink:  false,
    privateNetwork:  false,
    bandwidth: {
      maximumBandwidth: 15000,
      typicalBandwidth: 2000
    }
  )
end

# Network set that will be used for the examples below
oneview_network_set 'NetworkSet_3001' do
  client my_client
  ethernet_network_list ['ChefEthernet_3001']
end

# FC network that will be used for the examples below
oneview_fc_network 'Fibre Channel A' do
  client my_client
  data(
    fabricType: 'FabricAttach',
    autoLoginRedistribution: true
  )
end

# Example: Update the connection template for an ethernet network
oneview_connection_template 'Update connection template for ChefEthernet_3001' do
  client my_client
  associated_ethernet_network 'ChefEthernet_3001'
  data(
    bandwidth: {
      maximumBandwidth: 13500,
      typicalBandwidth: 2200
    }
  )
end

# Example: Reset the connection template for an ethernet network
oneview_connection_template 'Reset connection template for ChefEthernet_3001' do
  client my_client
  associated_ethernet_network 'ChefEthernet_3001'
  action :reset
end

# Example: Update the connection template for a fiber channel network
oneview_connection_template 'Update connection template for Fibre Channel A' do
  client my_client
  associated_fc_network 'Fibre Channel A'
  data(
    bandwidth: {
      maximumBandwidth: 1000 * 8, # 8Gb/s
      typicalBandwidth: 1000 * 8
    }
  )
end

# Example: Reset the connection template for a fiber channel network
oneview_connection_template 'Reset connection Fibre Channel A' do
  client my_client
  associated_fc_network 'Fibre Channel A'
  action :reset
end

# Example: Update the connection template for a network set
oneview_connection_template 'Update connection template for NetworkSet_3001' do
  client my_client
  associated_network_set 'NetworkSet_3001'
  data(
    bandwidth: {
      maximumBandwidth: 13500,
      typicalBandwidth: 2200
    }
  )
end

# Cleanup:
oneview_ethernet_network 'ChefEthernet_3001' do
  client my_client
  action :delete
end

oneview_network_set 'NetworkSet_3001' do
  client my_client
  action :delete
end

oneview_fc_network 'Fibre Channel A' do
  client my_client
  action :delete
end

