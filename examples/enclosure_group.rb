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

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 3000,
  api_variant: 'Synergy'
}

OneviewCookbook::Helper.load_sdk(self)
lig = OneviewCookbook::Helper.load_resource(my_client, type: 'LogicalInterconnectGroup', id: 'LIG-EG')

interconnect_bay_mapping = [
       { interconnectBay: 3, logicalInterconnectGroupUri: lig['uri'] },
       { interconnectBay: 6, logicalInterconnectGroupUri: lig['uri'] }
]

oneview_enclosure_group 'Eg2' do
  data(
    stackingMode: 'Enclosure',
    interconnectBayMappingCount: 2,
    ipAddressingMode: 'External',
    enclosureCount: 2,
    interconnectBayMappings: interconnect_bay_mapping
  )
  logical_interconnect_groups ['LIG-EG']
  client my_client
  action :create
end

# The set_script action is only available for C7000.
oneview_enclosure_group 'Eg2' do
  client my_client
  api_variant 'C7000'
  script '#TEST COMMAND'
  action :set_script
  only_if { client[:api_variant] == 'C7000' }
end

oneview_enclosure_group 'Eg2' do
  client my_client
  action :delete
end
