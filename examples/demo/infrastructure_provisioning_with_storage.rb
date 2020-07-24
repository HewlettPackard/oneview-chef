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

# Be able to provision compute (with server settings), networking, and storage.
#	Create a server profile template with the following options:
#		Network connections
#		Boot mode
#		Boot settings
#		Shares volume from the provided storage
#		Create a server profile from a server profile template and assign to hardware
#		Power on server
# This example works for api_variant "Synergy".
# This example works with either resource uri or resource name.
# This example has been tested againts Oneview API Version 800.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 1800
}

my_server_hardware_type = 'SY 480 Gen9 2'
my_enclosure_group = 'EG'
my_fc_network_data = [
  {
    FC01: {
      id: 1,
      name: 'con1',
      functionType: 'FibreChannel',
      portId: 'Mezz 3:1-b'
    }
  },
  {
    FC02: {
      id: 2,
      name: 'con2',
      functionType: 'FibreChannel',
      portId: 'Mezz 3:2-b'
    }
  }
]
volume_attachment_data = [
  host_os_type: 'VMware (ESXi)',
  attachment_data: { id: 1, lun: '', lunType: 'Auto', storagePaths: [
    { connectionId: 1,
      isEnabled: true,
      targetSelector: 'Auto' },
    { connectionId: 2,
      isEnabled: true,
      targetSelector: 'Auto' }
  ] },
  volume: 'SYN_Vol_1'
]

# To create server profile template
oneview_server_profile_template 'SPT-102' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  fc_network_connections my_fc_network_data
  volume_attachments volume_attachment_data
  data(
    boot: { manageBoot: true, order: ['CD', 'USB', 'HardDisk', 'PXE'] },
    bootMode: { manageMode: true, mode: 'BIOS', secureBoot: 'Disabled' },
    bios: { manageBios: true }
  )
  action :create_if_missing
end

# Creating SP with FC and ethernet networks
oneview_server_profile 'SP' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  server_profile_template 'SPT-102'
  server_hardware 'SYN03_Frame1, bay 3'
end

# Power on the server

oneview_server_hardware 'SYN03_Frame1, bay 3' do
  client my_client
  power_state 'on'
  action :set_power_state
end
