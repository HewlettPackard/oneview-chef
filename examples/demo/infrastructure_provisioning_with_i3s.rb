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

# This example is used to provision an Infrastructure with OS on Synergy with Image Streamer.

# Be able to provision compute (with server settings), networking, and OS Deployment.
#       Create a server profile template with the following options:
#               OS Deployment Settings
#               Network connections
#               Boot mode
#               Boot settings
#               Create a server profile from a server profile template and assign to hardware
#               Power on server
# This example works for api_variant "Synergy".
# This example works with either resource uri or resource name.
# This example has been tested againts Oneview API Version 800.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 800
}

my_server_hardware_type = 'SY 480 Gen9 2'
my_enclosure_group = 'SYN03_EC'

my_eth_connections = [
  { vlan512:  {
    id: 1,
    name: 'dep1',
    functionType: 'Ethernet',
    portId: 'Mezz 3:1-a',
    boot: { priority: 'Primary', bootVolumeSource: 'UserDefined', ethernetBootType: 'iSCSI' },
    ipv4: { ipAddressSource: 'SubnetPool' }
  } },
  { vlan512: {
    id: 2,
    name: 'dep2',
    functionType: 'Ethernet',
    portId: 'Mezz 3:2-a',
    boot: { priority: 'Secondary', bootVolumeSource: 'UserDefined', ethernetBootType: 'iSCSI' },
    ipv4: { ipAddressSource: 'SubnetPool' }
  } },
  { vlan504: {
    id: 3,
    name: 'c1',
    functionType: 'Ethernet',
    portId: 'Mezz 3:1-c',
    boot: { priority: 'NotBootable' }
  } },
  { vlan504: {
    id: 4,
    name: 'c2',
    functionType: 'Ethernet',
    portId: 'Mezz 3:2-c',
    requestedMbps: '2000',
    boot: { priority: 'NotBootable' }
  } }
]

my_deployment_plan = 'Ansible-demo-ubuntu'

# To create server profile template with i3s settings.
oneview_server_profile_template 'SP-102-IS' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  os_deployment_plan my_deployment_plan
  ethernet_network_connections my_eth_connections
  data(
    boot: { manageBoot: true, order: ['HardDisk'] },
    bootMode: { manageMode: true, mode: 'UEFIOptimized', pxeBootPolicy: 'Auto' },
    bios: { manageBios: true }
  )
  action :create_if_missing
end

# Creates Server Profile from the Server Profile Teamplate.
oneview_server_profile 'SP-IS-asis' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  server_profile_template 'ProfileTemplate101-IS-asis'
  server_hardware 'SYN03_Frame1, bay 12'
end

# Powers on the server.
oneview_server_hardware 'SYN03_Frame1, bay 12' do
  client my_client
  power_state 'on'
  action :set_power_state
end
