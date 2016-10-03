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

# Example: Upload a firmware bundle
oneview_firmware '/bundles/firmware_bundle_name.iso' do
  client my_client
end

# Example: Create a custom spp
# Uses spp_name and hotfixes_names
oneview_firmware 'CustomSPP' do
  client my_client
  spp_name 'Service Pack for ProLiant'
  hotfixes_names [
    'Online ROM Flash Component for Windows x64 - HPE Synergy 620/680 Gen9 Compute Module'
  ]
  action :create_custom_spp
end

# Example: Create a custom spp
# Uses spp_file and hotfixes_files as reference
oneview_firmware 'CustomSPP' do
  client my_client
  spp_files '/bundles/firmware_bundle_name.iso'
  hotfixes_files [
    '/bundles/hotfix_name.rpm'
  ]
  action :create_custom_spp
end

# Example: Remove a firmware
oneview_firmware '/bundles/firmware_bundle_name.iso' do
  client my_client
  action :remove
end
