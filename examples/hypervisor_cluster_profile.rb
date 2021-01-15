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

OneviewCookbook::Helper.load_sdk(self)

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 2200
}

hcm = OneviewCookbook::Helper.load_resource(my_client, type: 'HypervisorManager', id: 'HCM')
dp = OneviewCookbook::Helper.load_resource(my_client, type: 'OSDeploymentPlan', id: 'Esxi-6.2-U2-Deployment-Test')
spt = OneviewCookbook::Helper.load_resource(my_client, type: 'ServerProfileTemplate', id: 'SPT-Test')

# Example: Creates hypervisor cluster profile with attributes set in data.
oneview_hypervisor_cluster_profile 'Cluster5' do
  client my_client
  data(
  type: 'HypervisorClusterProfileV4',
  hypervisorManagerUri: hcm['uri'],
  path: 'DC2',
  hypervisorType: 'Vmware',
  hypervisorHostProfileTemplate: {
    serverProfileTemplateUri: spt['uri'],
    deploymentPlan: {
      deploymentPlanUri: dp['uri'],
      serverPassword: '<serverPassword>'},
    hostprefix: 'Test-Cluster-Host'})
  action :create
end

# Example: Updates the Cluster5 Hypervisor CLuster Profile with attributes given in data.
oneview_hypervisor_cluster_profile 'Cluster5' do
  client my_client
  data(
   type: 'HypervisorClusterProfileV4',
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
