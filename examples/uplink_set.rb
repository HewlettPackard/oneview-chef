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
# - Ethernet Networks: Ethernet1, Ethernet2
# - FC Network: FCNetwork1
# - FCoE Network: FCoENetwork1
# - Logical Interconnect: LogicalInterconnect1
# - Enclosure: MyEnclosure

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# Example: creates or updates an uplink set
# The Ethernet, FC, FCoE and Native Networks, as well as the associated Logical Interconnect,
# could be more conveniently declared by their names outside the data hash, as in the following
# example (URIs will not be accepted in this case). Notice that you can also declare an Enclosure
# within the locationEntries parameter by the Enclosure name instead of its URI.
# The portConfigInfos parameter is optional, as OneView creates it for you)
oneview_uplink_set 'UplinkSet1' do
  client my_client
  data(
    reachability: 'Reachable',
    manualLoginRedistributionState: 'NotSupported',
    connectionMode: 'Auto',
    lacpTimer: 'Short',
    networkType: 'Ethernet',
    ethernetNetworkType: 'Tagged',
    description: 'Created by Chef',
    portConfigInfos:
    [
      location:
      {
        locationEntries:
        [
          { value: 'MyEnclosure', type: 'Enclosure' }
        ]
      }
    ]
  )
  logical_interconnect 'LogicalInterconnect1' # Name of the associated logical interconnect
  networks ['Ethernet1', 'Ethernet2'] # Array of strings containing the name of the associated ethernet networks (can be empty - [])
  fc_networks ['FCNetwork1'] # Array of strings containing the name of the associated fc networks (can be empty - [])
  fcoe_network ['FCoENetwork1'] # Array of strings containing the name of the associated fcoe networks (can be empty - [])
  native_network nil # Name of the native network (can be nil)
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
    description: nil
  )
  action :create_if_missing
end

# Example: deletes an uplink set
oneview_uplink_set 'UplinkSet1' do
  client my_client
  action :delete
end
