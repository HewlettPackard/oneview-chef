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

oneview_rack 'Rack_1' do
  client my_client
end

oneview_rack 'Rack_1' do
  client my_client
  mount_options(
    name: 'UnmanagedILO_1',
    topUSlot: 20,
    type: 'UnmanagedDevice'
  )
  action :add_to_rack
end

oneview_rack 'Rack_1' do
  client my_client
  mount_options(
    name: 'UnmanagedILO_1',
    type: 'UnmanagedDevice'
  )
  action :remove_from_rack
end


oneview_rack 'Rack_1' do
  client my_client
  action :remove
end
