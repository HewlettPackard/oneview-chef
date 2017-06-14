# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
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

property :pool_type, String
property :id_list, Array
property :count, Integer

default_action :allocate_list

action :enable do
  OneviewCookbook::Helper.do_resource_action(self, :IDPool, :enable)
end

action :disable do
  OneviewCookbook::Helper.do_resource_action(self, :IDPool, :disable)
end

action :allocate_list do
  OneviewCookbook::Helper.do_resource_action(self, :IDPool, :allocate_list)
end

action :allocate_count do
  OneviewCookbook::Helper.do_resource_action(self, :IDPool, :allocate_count)
end

action :collect_ids do
  OneviewCookbook::Helper.do_resource_action(self, :IDPool, :collect_ids)
end

action :validate do
  OneviewCookbook::Helper.do_resource_action(self, :IDPool, :validate)
end
