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
  api_version: 800
}

my_server_hardware_type = 'DL380p Gen8 1'
my_enclosure_group = 'SYN03_EC'

# To create server profile template
oneview_server_profile_template 'SP-101' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  data(
    connectionSettings: { manageConnections: true, connections: [
      { id:  1,
        networkUri: '/rest/fc-networks/429006d8-24e2-4c52-8e08-58a1ea1cb985',
        functionType: 'FibreChannel',
        portId: 'Mezz 3:1-b' },
      { id: 2,
        networkUri: '/rest/fc-networks/7884fa5e-1b5a-4f56-b52c-459884bccaea',
        functionType: 'FibreChannel',
        portId: 'Mezz 3:2-b' }
    ] },
    boot: { manageBoot: true, order: ['CD', 'USB', 'HardDisk', 'PXE'] },
    bootMode: { manageMode: true, mode: 'BIOS', secureBoot: 'Disabled' },
    bios: { manageBios: true },
    sanStorage: { manageSanStorage: true, hostOSType: 'VMware (ESXi)', volumeAttachments: [
      { id: 1,
        lun: '',
        lunType: 'Auto',
        volumeUri: '/rest/storage-volumes/B9981C13-EED1-4F21-B95F-A93D00D23E3F', storagePaths: [
          { connectionId: 1,
            isEnabled: true,
            targetSelector: 'Auto' },
          { connectionId: 2,
            isEnabled: true,
            targetSelector: 'Auto' }
        ] }
    ] }
  )
  action :create_if_missing
end

# Creating SP with FC and ethernet networks

oneview_server_profile 'SP-asis' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  server_profile_template 'SP-101'
  server_hardware 'SYN03_Frame1, bay 3'
end

# Power on the server

oneview_server_hardware 'SYN03_Frame1, bay 3' do
  client my_client
  power_state 'on'
  action :set_power_state
end
