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

# Defaults API version to 300
node.default['oneview']['api_version'] = 300

oneview_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

i3s_client = {
  url: ENV['I3S_URL'],
  oneview_client: oneview_client
}

# Create the Plan scripts
image_streamer_plan_script 'ESXi - Configure environment' do
  client i3s_client
  data(
    hpProvided: false,
    planType: 'deploy',
    content: File.open('my/script/path/configure_environment.sh', 'rb').read
  )
end

image_streamer_plan_script 'ESXi - Set credentials' do
  client i3s_client
  data(
    hpProvided: false,
    planType: 'deploy',
    content: File.open('my/script/path/set_credentials.sh', 'rb').read
  )
end

image_streamer_os_build_plan 'ESXi - Build simple environment' do
  client i3s_client
  data(
    oeBuildPlanType: 'Deploy',
    buildStep: [
      { serialNumber: 1, planScriptName: 'ESXi - Configure environment' },
      { serialNumber: 2, planScriptName: 'ESXi - Set credentials' }
    ]
  )
end

image_streamer_golden_image 'GoldenImage - Deploy1' do
  client i3s_client
  os_volume 'OSVolume1'
  data(
    imageCapture: false # Deploy
  )
end

image_streamer_deployment_plan 'DeploymentPlan1' do
  client i3s_client
  data(
    hpProvided: false
  )
  os_build_plan 'ESXi - Build simple environment'
  golden_image 'GoldenImage - Deploy1'
end

oneview_server_profile_template 'WebServerTemplate1' do
  client oneview_client
  profile_name 'ESXi - WebServer1'
  action :new_profile
end

oneview_server_profile 'ESXi - WebServer1' do
  client oneview_client
  os_deployment_plan 'ESXi - Build simple environment'
  server_hardware 'SY0000, bay 1'
end
