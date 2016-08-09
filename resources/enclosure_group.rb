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

property :script, String
property :logical_interconnect_group, String # Name of LIG

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :create do
  item = load_resource
  if logical_interconnect_group
    lig = OneviewSDK::LogicalInterconnectGroup.new(item.client, name: logical_interconnect_group)
    item.add_logical_interconnect_group(lig)
  end
  create_or_update(item)
end

action :create_if_missing do
  item = load_resource
  if logical_interconnect_group
    lig = OneviewSDK::LogicalInterconnectGroup.new(item.client, name: logical_interconnect_group)
    item.add_logical_interconnect_group(lig)
  end
  create_if_missing(item)
end

action :delete do
  delete
end

action :set_text_script do
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
