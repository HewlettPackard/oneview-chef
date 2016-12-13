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

# Example: Add an empty rack with default values
oneview_rack 'Rack_1' do
  client my_client
end

# Example: Add an empty rack with some options
# Note that you can also define all the info for the devices in the rack in the data hash, but the
# following examples show how to use the :add_to_rack & remove_from_rack actions to make this easier.
oneview_rack 'Rack_1' do
  client my_client
  data(
    depth:  1100,       # mm
    height: 2500,       # mm
    width:  800,        # mm
    uHeight: 40,
    thermalLimit: 2000, # watts
    serialNumber: 'FakeSN123456',
    model: 'HPE Standard Series Rack'
  )
end

# Example: Add a device to the rack
# Here we'll add an unmanaged device to the rack (the device we would like to add must exist already).
# This action uses the mount_options property to make it easier to add devices. Specify the type, name,
# and slot to align the top of the device with (uHeight & location are optional).
oneview_rack 'Rack_1' do
  client my_client
  mount_options(
    type: 'UnmanagedDevice',
    name: 'UnmanagedILO_1',
    topUSlot: 20,
    uHeight: 2,            # Optional
    location: 'CenterBack' # Optional
  )
  action :add_to_rack
end

# Example: Remove a device from the rack
oneview_rack 'Rack_1' do
  client my_client
  mount_options(
    name: 'UnmanagedILO_1',
    type: 'UnmanagedDevice'
  )
  action :remove_from_rack
end

# Example: Remove a rack
oneview_rack 'Rack_1' do
  client my_client
  action :remove
end
