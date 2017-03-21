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

# Ethernet network that we'll use for the examples below
oneview_ethernet_network 'ChefEthernet_3001' do
  client client
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

# Network set that we'll use for the examples below
oneview_network_set 'NetworkSet_3001' do
  client oneview_sdk_client
  ethernet_network_list ['ChefEthernet_3001']
end


# FC network that we'll use for the examples below
oneview_fc_network 'Fibre Channel A' do
  client client
  data(
    fabricType: 'FabricAttach',
    autoLoginRedistribution: true
  )
end

oneview_connection_template 'Reset connection ChefEthernet_3001' do
  client client
  associated_ethernet_network 'ChefEthernet_3001'
  action :reset
end

oneview_connection_template 'Update connection ChefEthernet_3001' do
  client client
  associated_ethernet_network 'ChefEthernet_3001'
  data(
    bandwidth: {
      maximumBandwidth: 13500,
      typicalBandwidth: 2200
    }
  )
end

oneview_ethernet_network 'ChefEthernet_3001' do
  client client
  action :reset_connection_template
end

oneview_ethernet_network 'ChefEthernet_3001' do
  client client
  action :delete
end

# Reset FC Network bandwidth parameters
oneview_connection_template 'Reset connection Fibre Channel A' do
  client client
  associated_fc_network 'Fibre Channel A'
  action :reset
end

# Set FC Network bandwidth parameters
oneview_connection_template 'Update connection Fibre Channel A' do
  client client
  associated_fc_network 'Fibre Channel A'
  data(
    bandwidth: {
      maximumBandwidth: 1000 * 8, # 8Gb/s
      typicalBandwidth: 1000 * 8
    }
  )
end

# Set Network Set bandwidth parameters
oneview_connection_template 'Update network set NetworkSet_3001' do
  client client
  associated_network_set 'NetworkSet_3001'
  data(
    bandwidth: {
      maximumBandwidth: 13500,
      typicalBandwidth: 2200
    }
  )
end
