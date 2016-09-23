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
oneview_firmware_bundle 'firmware_bundle_name.iso' do
  client my_client
  file_path '/bundles/firmware_bundle_name.iso'
end

# Example: Upload a firmware bundle
# This is functionally the same as above, but uses the name attribute to specify the file path
oneview_firmware_bundle '/bundles/firmware_bundle_name.iso' do
  client my_client
end
