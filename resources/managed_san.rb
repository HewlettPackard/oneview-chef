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

default_action :none

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :set_refresh_state do
  item = load_resource
  temp = item['refreshState']
  raise "Resource not found: #{resource_name} '#{item['name']}'" unless item.exists?

  item.retrieve!
  if item['refreshState'] != temp
    Chef::Log.info "Refreshing #{resource_name} '#{name}'"
    converge_by "#{resource_name} '#{name}' refreshed" do
      item.set_refresh_state(temp)
    end
  else
    Chef::Log.info "#{resource_name} '#{name}' is already #{temp}"
  end
end

action :set_policy do
  item = load_resource
  temp = Marshal.load(Marshal.dump(item['sanPolicy']))
  raise "Resource not found: #{resource_name} '#{item['name']}'" unless item.exists?

  item.retrieve!
  if temp.all? { |k, v| v == item['sanPolicy'][k] }
    Chef::Log.info "#{resource_name} '#{name}' san policy is up to date"
  else
    Chef::Log.info "Updating #{resource_name} '#{name}' san policy"
    converge_by "#{resource_name} '#{name}' san policy updated" do
      item.set_san_policy(temp)
    end
  end
end

action :set_public_attributes do
  item = load_resource
  temp = Marshal.load(Marshal.dump(item['publicAttributes']))
  raise "Resource not found: #{resource_name} '#{item['name']}'" unless item.exists?

  item.retrieve!
  # compares two hashes
  results = []
  temp = temp.each_with_index do |element, index|
    results << element.all? { |k, v| v == item['publicAttributes'][index][k] }
  end

  if results.all?
    Chef::Log.info "#{resource_name} '#{name}' public attributes are up to date"
  else
    Chef::Log.info "Updating #{resource_name} '#{name}' public attributes"
    converge_by "#{resource_name} '#{name}' public attributes updated" do
      item.set_public_attributes(temp)
    end
  end
end

action :none do
end
