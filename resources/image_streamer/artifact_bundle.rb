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

OneviewCookbook::ResourceBaseProperties.load(self)

property :deployment_plans, Array, default: []
property :golden_images, Array, default: []
property :os_build_plans, Array, default: []
property :plan_scripts, Array, default: []
property :new_name, String
property :file_path, String
property :deployment_group, String
property :timeout, Integer

resource_name :image_streamer_artifact_bundle

default_action :create_if_missing

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :create_if_missing, OneviewCookbook::ImageStreamer)
end

action :update_name do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :update_name, OneviewCookbook::ImageStreamer)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :delete, OneviewCookbook::ImageStreamer)
end

action :download do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :download, OneviewCookbook::ImageStreamer)
end

action :upload do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :upload, OneviewCookbook::ImageStreamer)
end

action :extract do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :extract, OneviewCookbook::ImageStreamer)
end

action :backup do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :backup, OneviewCookbook::ImageStreamer)
end

action :backup_from_file do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :backup_from_file, OneviewCookbook::ImageStreamer)
end

action :download_backup do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :download_backup, OneviewCookbook::ImageStreamer)
end

action :extract_backup do
  OneviewCookbook::Helper.do_resource_action(self, :ArtifactBundle, :extract_backup, OneviewCookbook::ImageStreamer)
end
