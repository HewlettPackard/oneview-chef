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

# Creates the artifact bundle and assigns resources to it.
image_streamer_artifact_bundle 'ArtifactBundle1' do
  client i3s_client
  data(
    description: 'AnyDescription'
  )
  os_build_plans [{ name: 'BP', read_only: false }]
  deployment_plans [{ name: 'DP', read_only: false }]
  golden_images [{ name: 'GI', read_only: false }]
  plan_scripts [{ name: 'PS', read_only: false }]
  action :create_if_missing
end

# Downloads the artifact bundle to the path specified
image_streamer_artifact_bundle 'ArtifactBundle1' do
  client i3s_client
  file_path '/tmp/AB01.zip'
  action :download
end

# Updates the name of the Artifact Bundle 'ArtifactBundle1' to 'ArtifactBundle2'
image_streamer_artifact_bundle 'ArtifactBundle1' do
  client i3s_client
  new_name 'ArtifactBundle2'
  action :update_name
end

# Uploads the artifact bundle downloaded before, recreating 'ArtifactBundle1'
image_streamer_artifact_bundle 'ArtifactBundle1' do
  client i3s_client
  file_path '/tmp/AB01.zip'
  action :upload
end

# Extracts the selected artifact bundle and creates the artifacts on the appliance.
image_streamer_artifact_bundle 'ArtifactBundle1' do
  client i3s_client
  action :extract
end

# Creates a backup bundle with all the artifacts present on the appliance. At any given point only one backup bundle will exist on the appliance.
image_streamer_artifact_bundle 'DeploymentGroup1' do
  client i3s_client
  action :backup
end

# Downloads the backup bundle from the appliance to the path specified.
image_streamer_artifact_bundle 'BKP01' do
  client i3s_client
  file_path '/tmp/BKP01.zip'
  action :download_backup
end

# Upload a backup bundle from a local drive and extract all the artifacts present in the uploaded file.
image_streamer_artifact_bundle 'BKP01' do
  client i3s_client
  file_path '/tmp/BKP01.zip'
  deployment_group 'DeploymentGroup1'
  timeout 300
  action :backup_from_file
end

# Extracts the existing backup bundle on the appliance and creates all the artifacts.
image_streamer_artifact_bundle 'BKP01' do
  client i3s_client
  file_path '/tmp/BKP01.zip'
  action :extract_backup
end

# Deletes the artifacts bundle specified.
image_streamer_artifact_bundle 'ArtifactBundle1' do
  client i3s_client
  action :delete
end
