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

# NOTE:
#  It is needed configure previously some things like the network connections, storage pool, storage system, etc., to run this example.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

enclosure_group = 'EG_1'
server_hardware_type = 'BL660c Gen9 1'
sp_name = 'sp1'

# use this to create server profile template with volume attachments using api200 or api300
volume_data_api_200 = {
  name: 'Volume1',
  description: 'volume for api200 or api300',
  provisioningParameters: {
    provisionType: 'Full',
    requestedCapacity: 1024 * 1024 * 1024,
    shareable: false
  }
}

# use this to create server profile template with volume attachments using api500 or greater
volume_data_api_500 = {
  name: 'Volume1',
  description: 'Volume store serv for api500',
  size: 1024 * 1024 * 1024,
  provisioningType: 'Thin',
  isShareable: false
}

# use this to add storage paths to volume attachments using api200 or api300
storage_paths_api_200 = [
  {
    isEnabled: true,
    storageTargetType: 'Auto',
    connectionId: 1
  }
]

# use this to add storage paths to volume attachments using api500 or greater
storage_paths_api_500 = [
  {
    isEnabled: true,
    targetSelector: 'Auto',
    connectionId: 1
  }
]

# Creates on server profile template with the desired Enclosure group and Server hardware type
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  enclosure_group enclosure_group
  server_hardware_type server_hardware_type
  fc_network_connections(
    FCNetwork1: {
      id: 1,
      name: 'Connection1',
      functionType: 'FibreChannel',
      portId: 'Auto'
    }
  )
  volume_attachments(
    [
      {
        volume: 'test2',
        attachment_data: {
          id: 1,
          lunType: 'Auto',
          storagePaths: storage_paths_api_200
        }
      },
      {
        volume_data: volume_data_api_200,
        storage_system: 'ThreePAR-1',
        storage_pool: 'cpg-growth-limit-1TiB',
        host_os_type: 'Windows 2012 / WS2012 R2',
        attachment_data: {
          id: 2,
          lunType: 'Auto',
          storagePaths: storage_paths_api_200
        }
      }
    ]
  )
end

# Creates on server profile template with the desired Enclosure group and Server hardware type
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  enclosure_group enclosure_group
  server_hardware_type server_hardware_type
  action :create_if_missing
end

# Creates a server profile template using the server profile 'sp1' as a templates
# Note: Only to api 500 or greater, comments this recipe if you do not running using api500
oneview_server_profile_template 'ServerProfileTemplate2' do
  client my_client
  api_version 500
  server_profile_name sp_name
end

# Deletes server profile 'ServerProfileTemplate1'
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  action :delete
end

# Deletes server profile 'ServerProfileTemplate2'
oneview_server_profile_template 'ServerProfileTemplate2' do
  client my_client
  action :delete
end
