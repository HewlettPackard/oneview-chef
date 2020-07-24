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

# NOTE: This recipe requires:
# Enclosure group: Eg1
# Scopes: Scope1, Scope2

# NOTE 2: The api_version client should be 300 or greater if you run the examples using Scopes

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 1800
}

oneview_enclosure 'Encl1' do
  data(
    hostname: '172.18.1.11',
    username: 'dcs',
    password: 'dcs',
    licensingIntent: 'OneView'
  )
  enclosure_group 'Eg1'
  client my_client
  action :add
end

#Generate certificate Signing Request
oneview_enclosure 'e10' do
  client my_client
  bay_number 1
  csr_file_path 'file_path_of_csr_file'
  csr_data(
    type: 'CertificateDtoV2',
    organization: 'Acme Corp.',
    organizationalUnit: 'IT',
    locality: 'Townburgh',
    state: 'Mississippi',
    country: 'US',
    email: 'admin@example.com',
    commonName: 'fe80::2:0:9:1%eth2'
  )
  action :create_csr_request
end

#Import a signed server certtificate into 'Encl1'
oneview_enclosure 'e10' do
  client my_client
  bay_number 1
  csr_file_path 'file_path_of_csr_file'
  csr_type 'CertificateDataV2'
  action :import_certificate
end

# Rename enclosure
# Warning: Operation persists in hardware
oneview_enclosure 'Encl1' do
  client my_client
  operation 'replace'
  path '/name'
  value 'ChefEncl1'
  action :patch
end

# Restoring its original name
oneview_enclosure 'ChefEncl1' do
  client my_client
  operation 'replace'
  path '/name'
  value 'Encl1'
  action :patch
end

# Refreshes the enclosure
oneview_enclosure 'Encl1' do
  client my_client
  action :refresh
end

# Supported for API 300 till 500
# Adds 'Encl1' to 'Scope1' and 'Scope2'
oneview_enclosure 'Encl1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
end

# Supported for API 300 till 500
# Removes 'Encl1' from 'Scope1'
oneview_enclosure 'Encl1' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
end

# Supported for API 300 till 500
# Replaces 'Scope1' and 'Scope2' for 'Encl1'
oneview_enclosure 'Encl1' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
end

# Removes it from the appliance
oneview_enclosure 'Encl1' do
  client my_client
  action :remove
end
