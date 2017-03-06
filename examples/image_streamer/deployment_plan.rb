# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

oneview_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

i3s_client = {
  url: ENV['I3S_URL'],
  oneview_client: oneview_client
}

# Create or update the Deployment Plan named 'DeploymentPlan1'
image_streamer_deployment_plan 'DeploymentPlan1' do
  client i3s_client
  api_version 300
  data(
    description: 'AnyDescription',
    hpProvided: false
  )
  os_build_plan 'ChefBP01'
  golden_image 'ChefGI01'
end

# Update the Deployment Plan named 'DeploymentPlan1' with a new description
image_streamer_deployment_plan 'DeploymentPlan1' do
  client i3s_client
  api_version 300
  data(
    description: 'Chef created and updated Deployment Plan - 1'
  )
end

# Create the Deployment Plan named 'DeploymentPlan2' only if does not exist
image_streamer_deployment_plan 'DeploymentPlan2' do
  client i3s_client
  api_version 300
  data(
    description: 'example of create_if_missing action',
    hpProvided: false
  )
  os_build_plan 'ChefBP01'
  golden_image 'ChefGI01'
  action :create_if_missing
end

# Delete the Deployment Plan named 'DeploymentPlan1' if it exists
image_streamer_deployment_plan 'DeploymentPlan1' do
  client i3s_client
  api_version 300
  action :delete
end

# Delete the Deployment Plan named 'DeploymentPlan2' if it exists
image_streamer_deployment_plan 'DeploymentPlan2' do
  client i3s_client
  api_version 300
  action :delete
end
