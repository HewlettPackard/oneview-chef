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

client = {
  url: '',
  user: '',
  password: ''
}

storage_system_credentials = {
  ip_hostname: '',
  username: '',
  password: ''
}

oneview_storage_system 'Teste' do
  data ({
    credentials:storage_system_credentials,
    managedDomain: 'TestDomain'
  })
  client client
  action :add
end

oneview_storage_system 'ThreePAR7200-8147' do
  data ({
    credentials: {
      ip_hostname: '172.18.11.11',
      username: 'dcs'
    },
    refreshState: 'RefreshPending'
  })
  client client
  action :edit
end
