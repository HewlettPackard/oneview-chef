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

# NOTE: It assumes the server profile template 'WebServerTemplate1' was already created with all the connection information

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

# Create the Plan scripts to be executed during the provisioning step
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

# Create an OS build plan that lists the execution of the previously created plan scripts
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

# Create the Golden Image from 'OSVolume1'
image_streamer_golden_image 'GoldenImage - Deploy1' do
  client i3s_client
  os_volume 'OSVolume1'
  data(imageCapture: true)
end

# Create or update the Deployment Plan with the OS build plan and the golden image
image_streamer_deployment_plan 'ESXi - Deploy simple' do
  client i3s_client
  data(hpProvided: false)
  os_build_plan 'ESXi - Build simple environment'
  golden_image 'GoldenImage - Deploy1'
end

# Apply the server profile, based on the 'WebServerTemplate1' template to the 'Enclosure1, bay 1' server hardware blade
#   with the OS deployment plan 'ESXi - Deploy simple' from the last steps
oneview_server_profile 'ESXi - WebServer1' do
  client oneview_client
  server_profile_template 'WebServerTemplate1'
  server_hardware 'Enclosure1, bay 1'
  os_deployment_plan 'ESXi - Deploy simple'
end
