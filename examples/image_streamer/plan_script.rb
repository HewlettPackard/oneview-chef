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

# Create or update the Plan script named 'PlanScript1'
image_streamer_plan_script 'PlanScript1' do
  client i3s_client
  api_version 300
  data(
    description: 'Chef created Plan Script - 1',
    hpProvided: false,
    planType: 'deploy',
    content: 'f'
  )
end

# Update the Plan script named 'PlanScript1' with a new description
image_streamer_plan_script 'PlanScript1' do
  client i3s_client
  api_version 300
  data(
    description: 'Chef created and updated Plan Script - 1'
  )
end

# Create the Plan script named 'PlanScript2' only if does not exist
image_streamer_plan_script 'PlanScript2' do
  client i3s_client
  api_version 300
  data(
    description: 'Chef created Plan Script - 2',
    hpProvided: false,
    planType: 'deploy',
    content: 'f'
  )
  action :create_if_missing
end

# Delete the Plan script named 'PlanScript1' if it exists
image_streamer_plan_script 'PlanScript1' do
  client i3s_client
  api_version 300
  action :delete
end

# Delete the Plan script named 'PlanScript2' if it exist
image_streamer_plan_script 'PlanScript2' do
  client i3s_client
  api_version 300
  action :delete
end
