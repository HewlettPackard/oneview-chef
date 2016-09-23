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

property :switch_number, Fixnum
property :switch_type, String

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
  def load_logical_switch_group
    item = load_resource
    # This will avoid overriding the 'switchMapTemplate' if already specified in data
    return item unless item['switchMapTemplate'].empty?
    raise "Unspecified property: 'switch_number'. Please set it before attempting this action." unless switch_number
    raise "Unspecified property: 'switch_type'. Please set it before attempting this action." unless switch_type
    item.set_grouping_parameters(switch_number, switch_type)
    item
  end
end

action :create do
  create_or_update(load_logical_switch_group)
end

action :create_if_missing do
  create_if_missing(load_logical_switch_group)
end

action :delete do
  delete
end
