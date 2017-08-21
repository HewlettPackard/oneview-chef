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

oneview_fc_network 'Fc1-Create' do
  data(
    autoLoginRedistribution: true,
    fabricType: 'FabricAttach'
  )
  client my_client
  action :create
end

oneview_fc_network 'Fc1-Scope' do
  client my_client
  data(name: 'Fc1-Create')
  operation 'add'
  path '/scopeUris/-'
  value '/rest/scopes/7887dc77-c4b7-474a-9b9e-b7cba3d11d93'
  action :patch
end

oneview_fc_network 'Fc1-Delete' do
  client my_client
  data(name: 'Fc1-Create')
  action :delete
end
