################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

Opscode::OneviewResourceBaseProperties.load(self)

property :type, default: 'FCoENetwork'

default_action :create

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :create do
  create_or_update
end

action :create_if_missing do
  create_if_missing
end

action :delete do
  delete
end
