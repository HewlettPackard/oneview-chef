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

my_client = {
  url: 'https://10.50.4.100',
  user: 'asis_bagga',
  password: 'password123',
  api_version: 800,
  ssl_enabled: false
}

my_server_hardware_type = 'SY 480 Gen9 2'
my_enclosure_group = 'SYN03_EC'

# To create server profile template with i3s settings.
oneview_server_profile_template 'SP-101-IS' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  data(
    osDeploymentSettings: { osDeploymentPlanUri: '/rest/os-deployment-plans/056041be-a7b3-478f-8e78-a37fd80b6654' },
    connectionSettings: { manageConnections: true, connections: [
      { id: 1,
        networkUri: '/rest/ethernet-networks/29af1597-7f2e-45d8-aaed-ee1be6c42ae2',
        name: 'dep1',
        functionType: 'Ethernet',
        portId: 'Mezz 3:1-a',
        boot: { priority: 'Primary', bootVolumeSource: 'UserDefined', ethernetBootType: 'iSCSI' },
        ipv4: { ipAddressSource: 'SubnetPool' } },
      { id: 2,
        networkUri: '/rest/ethernet-networks/29af1597-7f2e-45d8-aaed-ee1be6c42ae2',
        name: 'dep2',
        functionType: 'Ethernet',
        portId: 'Mezz 3:2-a',
        boot: { priority: 'Secondary', bootVolumeSource: 'UserDefined', ethernetBootType: 'iSCSI' },
        ipv4: { ipAddressSource: 'SubnetPool' } },
      { id: 3,
        networkUri: '/rest/ethernet-networks/6de2920a-8ad4-4cd8-865c-1907d3b4682e',
        name: 'c1',
        functionType: 'Ethernet',
        portId: 'Mezz 3:1-c',
        boot: { priority: 'NotBootable' } },
      { id: 4,
        networkUri: '/rest/ethernet-networks/6de2920a-8ad4-4cd8-865c-1907d3b4682e',
        name: 'c2',
        functionType: 'Ethernet',
        portId: 'Mezz 3:2-c',
        requestedMbps: '2000',
        boot: { priority: 'NotBootable' } }
    ] },
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
