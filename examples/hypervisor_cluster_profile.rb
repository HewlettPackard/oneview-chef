# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
# NOTE:  Hypervisor Cluster Profile resource works for client version  API800 and greater.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 1200
}

# Example: Creates hypervisor cluster profile with attributes set in data.
oneview_hypervisor_cluster_profile 'Cluster5' do
  client my_client
  data(
  type: 'HypervisorClusterProfileV3',
  hypervisorManagerUri: '/rest/hypervisor-managers/8cf6690a-937f-4bf5-921e-f93405ef71d3',
  path: 'DC2',
  hypervisorType: 'Vmware',
  hypervisorHostProfileTemplate: {
    serverProfileTemplateUri: '/rest/server-profile-templates/ab05987d-0313-481c-81f2-583382960f51',
    deploymentPlan: {
    deploymentPlanUri: '/rest/os-deployment-plans/c7957678-8a8d-4493-ae60-7e508be548ca',
      serverPassword: 'dcs'},
    hostprefix: 'Test-Cluster-Host'})
  action :create
end

# Example: Updates the Cluster5 Hypervisor CLuster Profile with attributes given in data.
oneview_hypervisor_cluster_profile 'Cluster5' do
  client my_client
  data(
   type: 'HypervisorClusterProfileV3',
   description: 'This is updated description',
  )
  action :update
end

#Delets the Cluster5 Hypervisor Cluster Profile.
oneview_hypervisor_cluster_profile 'Cluster5' do 
  client my_client
  action :delete
end
