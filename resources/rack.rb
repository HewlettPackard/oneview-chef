# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

property :mount_options, Hash

default_action :add

action :add do
  OneviewCookbook::Helper.do_resource_action(self, :Rack, :add_or_edit)
end

action :add_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :Rack, :add_if_missing)
end

action :remove do
  OneviewCookbook::Helper.do_resource_action(self, :Rack, :remove)
end

action :add_to_rack do
  OneviewCookbook::Helper.do_resource_action(self, :Rack, :add_to_rack)
end

action :remove_from_rack do
  OneviewCookbook::Helper.do_resource_action(self, :Rack, :remove_from_rack)
end
