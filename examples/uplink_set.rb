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
  url: '',
  user: '',
  password: ''
}

# Example: creates or updates an uplink set
oneview_uplink_set 'UplinkSet1' do
  client my_client
  data(
    reachability: 'Reachable',
    manualLoginRedistributionState: 'NotSupported',
    connectionMode: 'Auto',
    lacpTimer: 'Short',
    networkType: 'Ethernet',
    ethernetNetworkType: 'Tagged',
    description: nil,
  )
  logical_interconnect 'LogicalInterconnect1'
  networks ['Ethernet1', 'Ethernet2']
  fc_networks['FCNetwork1']
  fcoe_network['FCoENetwork1']
  native_network nil
end

# Example: creates an uplink set if it does not exist yet
oneview_uplink_set 'UplinkSet1' do
  client my_client
  data(
    reachability: 'Reachable',
    manualLoginRedistributionState: 'NotSupported',
    connectionMode: 'Auto',
    lacpTimer: 'Short',
    networkType: 'Ethernet',
    ethernetNetworkType: 'Tagged',
    description: nil,
  )
  action :create_if_missing
end

# Example: deletes an uplink set
oneview_uplink_set 'UplinkSet1' do
  client my_client
  action :delete
end
