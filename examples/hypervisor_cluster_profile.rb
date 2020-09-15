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
# NOTE: Hypervisor Cluster Profile resource works for client version  API800 and greater.
# NOTE: Hypervisor manager and Server profile template should be created as a pre-requisite

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 2000
}

# Example: Creates hypervisor cluster profile with attributes set in data.
oneview_hypervisor_cluster_profile 'Cluster5' do
  client my_client
  data(
  type: 'HypervisorClusterProfileV3',
  hypervisorManagerUri: '/rest/hypervisor-managers/96ba2244-53d3-4f63-b556-806d771785b5',
  path: 'DC2',
  hypervisorType: 'Vmware',
  hypervisorHostProfileTemplate: {
    serverProfileTemplateUri: '/rest/server-profile-templates/edc7ee03-eb09-42ea-9d81-3887b8ebad38',
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

# Deletes the Cluster5 Hypervisor Cluster Profile.
# Delete method accepts 2 optional parameters(softDelete and force) till API1200
# In API1600, softDelete is mandatory paramter for delete method
# Either pass the 2 parameters in data or else don't pass data so that delete will consider 'false' as default values
oneview_hypervisor_cluster_profile 'Cluster5' do 
  client my_client
  data(
    force: true,
    softDelete: true
  )
  action :delete
end
