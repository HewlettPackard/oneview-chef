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

action :remove do
  item = load_resource
  found = item.retrieve!

  # Checks if the switch was already removed from oneview
  if found && 'Inventory' != item['state']
    converge_by "#{resource_name} '#{name}'" do
      item.remove
    end
  else
    Chef::Log.info "#{resource_name} '#{name}' is already in the inventory."
  end
end

action :none do
end
