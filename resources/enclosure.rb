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

property :enclosure_group, String # Name of Enclosure Group
property :state, String
property :options, Hash

default_action :add

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :add do
  item = load_resource
  if enclosure_group
    eg = OneviewSDK::EnclosureGroup.new(item.client, name: enclosure_group)
    item.set_enclosure_group(eg)
  end
  add_or_edit(item)
end

action :remove do
  remove
end

action :reconfigure do
  item = load_resource
  item.retrieve!

  if ['NotReapplyingConfiguration', 'ReapplyingConfigurationFailed', ''].include? item['reconfigurationState']
    converge_by "#{resource_name} '#{name}' was reconfigured." do
      item.configuration
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' configuration is already running.")
  end
end

action :refresh do
  item = load_resource
  item.retrieve!

  refresh_state = state || 'RefreshPending'
  refresh_options = options || {}

  if ['RefreshFailed', 'NotRefreshing', ''].include? item['refreshState']
    converge_by "#{resource_name} '#{name}' was refreshed." do
      item.set_refresh_state(refresh_state, refresh_options)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' refresh is already running.")
  end
end
