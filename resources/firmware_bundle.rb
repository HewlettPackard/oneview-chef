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

property :file_path, String

default_action :add

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :add do
  raise "Unspecified property: 'file_path'. Please set it before attempting this action." unless file_path
  load_sdk
  c = build_client(client)

  bundles_fw_components = OneviewSDK::FirmwareDriver.find_by(c, {}).map { |i| i['fwComponents'] }

  if bundles_fw_components.all? { |bundle| name != bundle.first['fileName'] }
    converge_by "Add #{resource_name} '#{name}'" do
      OneviewSDK::FirmwareBundle.add(c, file_path)
    end
  else
    Chef::Log.info "#{resource_name} '#{name}' is already up to date."
  end
end
