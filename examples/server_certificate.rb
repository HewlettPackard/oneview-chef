# (c) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE : The api_version client should be 600 or greater if you run the examples.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 3000
}

# Example: Action will do nothing
oneview_server_certificate "None" do
  client my_client
  action :none
end

# Example: It will get the certificate from the IP and imports it to oneview.
oneview_server_certificate "<serverIp>" do
  client my_client
  action :import_certificate
end

# Example: it will remove the certificate from oneview
oneview_server_certificate "<serverIp>" do
  client my_client
  action :remove_certificate
end

# Example: It will get the new certificate from IP mention and will update it certificate on the oneview appliance only if old certificate with same IP exist.
oneview_server_certificate "<serverIp>" do
  client my_client
  action :update_certificate
end
