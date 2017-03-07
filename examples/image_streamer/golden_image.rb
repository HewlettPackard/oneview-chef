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

# Create or update the Golden Image 'GoldenImage1'
image_streamer_golden_image 'GoldenImage1' do
  client i3s_client
  os_build_plan 'ESXi - Capture OS Build Plan'
  data(
    description: 'Chef created Golden Image',
    imageCapture: true
  )
end

# Create Golden Image 'GoldenImage2' if missing
image_streamer_golden_image 'GoldenImage2' do
  client i3s_client
  os_volume 'OSVolume1'
  data(
    description: 'Chef created Golden Image',
    imageCapture: true
  )
  action :create_if_missing
end

# Download the 'GoldenImage1' with timeout of 1200 seconds (20 minutes).
image_streamer_golden_image 'GoldenImage1' do
  client i3s_client
  file_path 'path/to/file/GoldenImage1_download.zip'
  timeout 20 * 60
  action :download
end

# Download the 'GoldenImage1' details archive.
image_streamer_golden_image 'GoldenImage1' do
  client i3s_client
  file_path 'path/to/file/GoldenImage1_details_archive.txt'
  action :download_details_archive
end

# Delete the 'GoldenImage1' and 'GoldenImage2'
image_streamer_golden_image 'GoldenImage1' do
  client i3s_client
  action :delete
end

image_streamer_golden_image 'GoldenImage2' do
  client i3s_client
  action :delete
end

# Upload the 'GoldenImage1' with timeout of 1800 seconds (30 minutes).
# If it already exists it won't upload.
image_streamer_golden_image 'GoldenImage1' do
  client i3s_client
  file_path 'path/to/file/GoldenImage1_download.zip'
  timeout 30 * 60
  action :upload_if_missing
end
