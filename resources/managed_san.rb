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

property :refresh_state, String, default: 'RefreshPending'

default_action :none

action :refresh do
  OneviewCookbook::Helper.do_resource_action(self, :ManagedSAN, :refresh)
end

action :set_policy do
  OneviewCookbook::Helper.do_resource_action(self, :ManagedSAN, :set_policy)
end

action :set_public_attributes do
  OneviewCookbook::Helper.do_resource_action(self, :ManagedSAN, :set_public_attributes)
end

action :none do
end
