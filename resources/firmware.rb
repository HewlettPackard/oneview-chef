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

property :spp_name, String
property :spp_file, String
property :hotfixes_names, Array
property :hotfixes_files, Array

default_action :add

action :add do
  OneviewCookbook::Helper.do_resource_action(self, :FirmwareDriver, :add_or_edit)
end

action :create_custom_spp do
  OneviewCookbook::Helper.do_resource_action(self, :FirmwareDriver, :create_custom_spp)
end

action :remove do
  OneviewCookbook::Helper.do_resource_action(self, :FirmwareDriver, :remove)
end
