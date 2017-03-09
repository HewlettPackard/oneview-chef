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

# Creates or updates a simple OS Build Plan named 'Chef-BuildPlan1'
image_streamer_os_build_plan 'Chef-OSBuildPlan1' do
  client i3s_client
  data(
    description: 'Chef created OS Build Plan',
    oeBuildPlanType: 'Deploy'
  )
end

# Creates or updates an OS Build Plan named 'Chef-BuildPlan1' with two build steps
# The first uses the plan script 'PlanScript1'
# The second uses the plan 'PlanScript2' with the parameter 'deploy'
image_streamer_os_build_plan 'Chef-OSBuildPlan1' do
  client i3s_client
  data(
    description: 'Chef created OS Build Plan',
    oeBuildPlanType: 'Deploy',
    buildStep: [
      { serialNumber: 1, planScriptName: 'PlanScript1' },
      { serialNumber: 2, planScriptName: 'PlanScript2', parameters: 'deploy' }
    ]
  )
end

# Creates a simple OS Build Plan named 'Chef-BuildPlan2' only if it does not exist
image_streamer_os_build_plan 'Chef-OSBuildPlan2' do
  client i3s_client
  data(
    description: 'Chef created OS Build Plan',
    oeBuildPlanType: 'Deploy'
  )
  action :create_if_missing
end

# Deletes the OS Build Plans created
image_streamer_os_build_plan 'Chef-OSBuildPlan1' do
  client i3s_client
  action :delete
end

image_streamer_os_build_plan 'Chef-OSBuildPlan2' do
  client i3s_client
  action :delete
end
