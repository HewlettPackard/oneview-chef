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

  def load_mount_item(client, mount_options)
    options = convert_keys(mount_options, :to_s)
    klass = get_resource_named(options['type'])
    mount_item = klass.new(client, name: options['name'])
    mount_item.retrieve!
    mount_item
  end
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
  item.retrieve!
  mount_item = load_mount_item(item.client, mount_options)

  rack_uris = item['rackMounts'].collect { |i| i['mountUri'] }
  options = convert_keys(mount_options, :to_s).reject! { |i| ['type', 'name'].include?(i) }
  if !rack_uris.include? mount_item['uri']
    converge_by "#{resource_name} '#{name}' added." do
      item.add_rack_resource(mount_item, options)
      item.update
    end
  else
    mounted_resource = item['rackMounts'].find { |i| i['mountUri'] == mount_item['uri'] }
    if options.any? { |k, v| v != mounted_resource[k] } # ~FC023
      converge_by "#{resource_name} '#{name}' updated." do
        item.add_rack_resource(mount_item, options)
        item.update
      end
    end
  end
end

action :remove_from_rack do
  item = load_resource
  item.retrieve!
  mount_item = load_mount_item(item.client, mount_options)

  rack_uris = item['rackMounts'].collect { |i| i['mountUri'] }
  if rack_uris.include? mount_item['uri'] # ~FC023
    converge_by "#{resource_name} '#{name}' removed." do
      item.remove_rack_resource(mount_item)
      item.update
    end
  end
end
