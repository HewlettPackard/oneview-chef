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

property :file_path, String, name_property: true

default_action :add

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :add do
  load_sdk
  c = build_client(client)

  file_name = ::File.basename(file_path)
  fw_bundles = OneviewSDK::FirmwareDriver.find_by(c, {}).map { |i| i['fwComponents'] }

  if fw_bundles.any? { |bundle| bundle.first['fileName'] == file_name }
    Chef::Log.info "#{resource_name} '#{file_name}' is already uploaded."
  else
    converge_by "Add #{resource_name} '#{file_path}'" do
      OneviewSDK::FirmwareBundle.add(c, file_path)
    end
  end
end
