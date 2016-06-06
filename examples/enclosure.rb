#################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

# NOTE: This recipe requires:
# Enclosure group: Eg1

client = {
  url: '',
  user: '',
  password: '',
  ssl_enabled: false
}

oneview_enclosure 'Encl1' do
  data ({
      hostname: '172.18.1.11',
      username: 'dcs',
      password: 'dcs',
      licensingIntent: 'OneView'
  })
  enclosure_group 'Eg1'
  client client
  action :add
end

oneview_enclosure 'Encl1' do
  client client
  action :remove
end
