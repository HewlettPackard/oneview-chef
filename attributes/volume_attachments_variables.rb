# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE: variables to be used within server_profile and server_profile_template examples.

# use this to create server profile or server profile template with volume attachments using api200 or api300
volume_data = {
  name: 'Volume1',
  description: 'volume for api200 or api300',
  provisioningParameters: {
    provisionType: 'Full',
    requestedCapacity: 1024 * 1024 * 1024,
    shareable: false
  }
}

# use this to create server profile or server profile template with volume attachments using api500 or greater
# volume_data = {
#   name: 'Volume1',
#   description: 'Volume store serv for api500',
#   size: 1024 * 1024 * 1024,
#   provisioningType: 'Thin',
#   isShareable: false
# }

# use this to add storage paths to volume attachments using api200 or api300
storage_paths = [
  {
    isEnabled: true,
    storageTargetType: 'Auto',
    connectionId: 1
  }
]

# use this to add storage paths to volume attachments using api500 or greater
# storage_paths = [
#   {
#     isEnabled: true,
#     targetSelector: 'Auto',
#     connectionId: 1
#   }
# ]

node.run_state['volume_data_for_volume_attachment'] = volume_data
node.run_state['storage_paths_for_volume_attachment'] = storage_paths
