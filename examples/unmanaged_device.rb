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
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# Example: Adds an unmanaged device (default action)
oneview_unmanaged_device 'UnmanagedDevice1' do
  client my_client
  data(
    model: 'Procurve 4200VL',
    deviceType: 'Server'
  )
end

# Example: Removes an unmanaged device
oneview_unmanaged_device 'UnmanagedDevice1' do
  client my_client
  action :remove
end
