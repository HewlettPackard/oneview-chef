#
# Cookbook Name:: oneview_test
# Recipe:: san_manager_add
#
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
#

oneview_san_manager '172.18.15.1' do
  client node['oneview_test']['client']
  data(
    providerDisplayName: 'Brocade Network Advisor',
    connectionInfo:
    [
      {
        name: 'Host',
        value: '172.18.15.1'
      },
      {
        name: 'Port',
        value: '5989'
      },
      {
        name: 'Username',
        value: 'Admin'
      },
      {
        name: 'Password',
        value: 'Secret123'
      },
      {
        name: 'UseSsl',
        value: true
      }
    ]
  )
end
