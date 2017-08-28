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

# NOTE: This example requires a Rack named "Rack_1" to be present in the appliance.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# Adds or edits one Datacenter view with the size of 3m x 5,1m
# It also places one rack named 'Rack_1' in the position 0,5m x 0,5m rotated 30 degrees clockwise
oneview_datacenter 'Datacenter_1' do
  client my_client
  data(
    width: 3000,
    depth: 5100
  )
  racks(
    Rack_1: {
      x: 500,
      y: 500,
      rotation: 30
    }
  )
end

# Creates a 3m x 7m Datacenter view named 'Datacenter_2' only if it does not exists
oneview_datacenter 'Datacenter_2' do
  client my_client
  data(
    width: 3000,
    depth: 7000
  )
  action :add_if_missing
end

# Remove the Datacenter named 'Datacenter_2'
oneview_datacenter 'Datacenter_2' do
  client my_client
  data(
    width: 3000,
    depth: 5100
  )
  action :remove
end
