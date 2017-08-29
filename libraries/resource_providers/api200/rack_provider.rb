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

module OneviewCookbook
  module API200
    # Rack API200 provider
    class RackProvider < ResourceProvider
      def load_mount_item
        options = convert_keys(@new_resource.mount_options, :to_s)
        load_resource(options['type'], options['name'])
      end

      def add_or_edit
        # Prevent the default initialization of the rackMounts property
        @item.data.delete('rackMounts') if @new_resource.data['rackMounts'].nil? && @item['rackMounts'] == []
        super
      end

      def add_to_rack
        raise "Unspecified property: 'mount_options'. Please set it before attempting this action." unless @new_resource.mount_options
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        mount_item = load_mount_item
        rack_uris = @item['rackMounts'].collect { |i| i['mountUri'] }
        options = convert_keys(@new_resource.mount_options, :to_s).reject! { |i| ['type', 'name'].include?(i) }
        if rack_uris.include? mount_item['uri']
          mounted_resource = @item['rackMounts'].find { |i| i['mountUri'] == mount_item['uri'] }
          return Chef::Log.info("Item '#{mount_item['name']}' in '#{@name}' is up to date") unless options.any? { |k, v| v != mounted_resource[k] }
          diff = get_diff(mounted_resource, options)
          Chef::Log.info "Updating #{mount_item['name']} in #{resource_name} '#{name}'#{diff}"
          @context.converge_by "Update #{mount_item['name']} in #{resource_name} '#{name}'" do
            @item.add_rack_resource(mount_item, options)
            @item.update
          end
        else
          @context.converge_by "Add #{mount_item['name']} to #{resource_name} '#{name}'" do
            @item.add_rack_resource(mount_item, options)
            @item.update
          end
        end
      end

      def remove_from_rack
        raise "Unspecified property: 'mount_options'. Please set it before attempting this action." unless @new_resource.mount_options
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        mount_item = load_mount_item
        rack_uris = @item['rackMounts'].collect { |i| i['mountUri'] }
        return Chef::Log.info("Item '#{mount_item['name']}' in '#{@name}' is up to date") unless rack_uris.include? mount_item['uri']
        @context.converge_by "Remove #{mount_item['name']} from #{resource_name} '#{name}'" do
          @item.remove_rack_resource(mount_item)
          @item.update
        end
      end
    end
  end
end
