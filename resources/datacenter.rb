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

property :racks, Hash, default: {}

default_action :add

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :add do
  item = load_resource
  add_racks(item)
  add_or_edit(item)
end

action :add_if_missing do
  item = load_resource
  add_racks(item)
  add_if_missing(item)
end

action :remove do
  remove
end

def add_racks(item)
  racks.each do |rack_name, rack_position|
    rack = OneviewSDK::Rack.new(item.client, name: rack_name.to_s)
    rack.retrieve!
    x = rack_position[:x] || 0
    y = rack_position[:y] || 0
    rotation = rack_position[:rotation] || 0
    item.add_rack(rack, x, y, rotation)
  end
end
