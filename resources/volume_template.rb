# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
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

property :storage_system, String
property :storage_pool, String
property :snapshot_pool, String

default_action :create

action :create do
  OneviewCookbook::Helper.do_resource_action(self, :VolumeTemplate, :create_or_update)
end

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :VolumeTemplate, :create_if_missing)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :VolumeTemplate, :delete)
end
