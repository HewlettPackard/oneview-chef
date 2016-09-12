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

property :mount_options, Hash

default_action :add

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :add do
  add_or_edit
end

action :add_if_missing do
  add_if_missing
end

action :remove do
  remove
end

action :add_to_rack do
  item = load_resource
  options = Hash[mount_options.map { |k, v| [k.to_s, v] }]
  klass = get_resource_named(options['type'])
  mount_item = klass.new(item.client, name: options['name'])
  mount_item.retrieve!
  item.retrieve!

  rack_resources = []
  item['rackMounts'].each { |value| rack_resources << value['mountUri'] }
  options = options.reject { |i| ['type', 'name'].include?(i) }
  if !rack_resources.include? mount_item['uri']
    converge_by "#{resource_name} '#{name}' added." do
      item.add_rack_resource(mount_item, options)
      item.update
    end
  else
    mounted_resource = item['rackMounts'].find { |i| i['mountUri'] == mount_item['uri'] }
    results = options.map { |key, value| value == mounted_resource[key.to_s] }
    unless results.all? # ~FC023
      converge_by "#{resource_name} '#{name}' updated." do
        item.add_rack_resource(mount_item, options)
        item.update
      end
    end
  end
end

action :remove_from_rack do
  item = load_resource
  options = Hash[mount_options.map { |k, v| [k.to_s, v] }]
  klass = get_resource_named(options['type'])
  mount_item = klass.new(item.client, name: options['name'])
  mount_item.retrieve!
  item.retrieve!

  rack_resources = []
  item['rackMounts'].each { |value| rack_resources << value['mountUri'] }
  if rack_resources.include? mount_item['uri'] # ~FC023
    converge_by "#{resource_name} '#{name}' removed." do
      item.remove_rack_resource(mount_item)
      item.update
    end
  end
end
