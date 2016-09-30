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
  item = load_resource
  # Prevent the default initialization of the rackMounts property
  item.data.delete('rackMounts') if data['rackMounts'].nil? && item['rackMounts'] == []
  add_or_edit(item)
end

action :add_if_missing do
  add_if_missing
end

action :remove do
  remove
end

action :add_to_rack do
  raise "Unspecified property: 'mount_options'. Please set it before attempting this action." unless mount_options
  item = load_resource
  item.retrieve!
  mount_item = load_mount_item(item.client, mount_options)

  rack_uris = item['rackMounts'].collect { |i| i['mountUri'] }
  options = convert_keys(mount_options, :to_s).reject! { |i| ['type', 'name'].include?(i) }
  if rack_uris.include? mount_item['uri']
    mounted_resource = item['rackMounts'].find { |i| i['mountUri'] == mount_item['uri'] }
    return unless options.any? { |k, v| v != mounted_resource[k] }
    diff = get_diff(mounted_resource, options)
    converge_by "Update #{mount_item['name']} in #{resource_name} '#{name}'#{diff}" do
      item.add_rack_resource(mount_item, options)
      item.update
    end
  else
    converge_by "Add #{mount_item['name']} to #{resource_name} '#{name}'" do
      item.add_rack_resource(mount_item, options)
      item.update
    end
  end
end

action :remove_from_rack do
  raise "Unspecified property: 'mount_options'. Please set it before attempting this action." unless mount_options
  item = load_resource
  item.retrieve!
  mount_item = load_mount_item(item.client, mount_options)

  rack_uris = item['rackMounts'].collect { |i| i['mountUri'] }
  return unless rack_uris.include? mount_item['uri']
  converge_by "Remove #{mount_item['name']} from #{resource_name} '#{name}'" do
    item.remove_rack_resource(mount_item)
    item.update
  end
end
