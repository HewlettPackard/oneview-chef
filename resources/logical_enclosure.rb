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

property :script, String # script for set_script action

default_action :update_from_group

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :update_from_group do
  item = load_resource
  raise "LogicalEnclosure '#{name}' not found!" unless item.retrieve!
  return if item['state'] == 'Consistent'
  converge_by "Update LogicalEnclosure '#{name}' from group" do
    item.update_from_group
  end
end

action :reconfigure do
  item = load_resource
  item.retrieve!

  item['enclosureUris'].each do |enclosure_uri|
    enclosure = OneviewSDK::Enclosure.new(item.client, uri: enclosure_uri)
    enclosure.retrieve!
    next unless ['NotReapplyingConfiguration', 'ReapplyingConfigurationFailed', ''].include? enclosure['reconfigurationState']
    converge_by "#{resource_name} '#{name}' was reconfigured." do
      item.reconfigure
    end
    return true
  end

  Chef::Log.info("#{resource_name} '#{name}' is already reconfiguring.")
end

action :set_script do
  item = load_resource
  item.retrieve!

  if item.get_script.eql? script
    Chef::Log.info("#{resource_name} '#{name}' script is up to date")
  else
    Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
    converge_by "Updated script for #{resource_name} '#{name}'" do
      item.set_script(script)
    end
  end
end
