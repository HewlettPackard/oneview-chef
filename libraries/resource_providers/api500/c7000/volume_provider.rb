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
  module API500
    module C7000
      # Volume API500 C7000 provider
      class VolumeProvider < API300::C7000::VolumeProvider
        def load_resource_with_associated_resources
          if @new_resource.volume_template
            load_volume_template
          else
            validate_required_properties(:storage_system, :storage_pool)
            load_storage_pool
            load_snapshot_pool if @new_resource.snapshot_pool
          end
          set_properties unless @item.exists?
        end

        def load_storage_system
          data = {
            hostname: @new_resource.storage_system,
            name: @new_resource.storage_system
          }
          @storage_system = load_resource(:StorageSystem, data)
        end

        def load_storage_pool
          load_storage_system
          super
        end

        def load_volume_template
          template = resource_named(:VolumeTemplate).new(@item.client, name: @new_resource.volume_template)
          @item.set_storage_volume_template(template)
          @item['storagePoolUri'] = template['storagePoolUri']
          @item['snapshotPoolUri'] = template['storagePoolUri'] if template['family'] == 'StoreServ'
        end

        def create_from_snapshot
          validate_required_properties(:properties)
          raise("#{@resource_name} '#{@name}' not found!") unless @item.retrieve!
          properties = convert_keys(@new_resource.properties, :to_s)
          properties['isShareable'] ||= @new_resource.is_shareable
          return Chef::Log.info "Volume '#{properties['name']}' already exists" if resource_named(:Volume).new(@item.client, name: properties['name']).retrieve!
          snapshot_name = properties['snapshotName']
          properties.delete('snapshotName')
          volume_template = nil
          volume_template = resource_named(:VolumeTemplate).new(@item.client, name: @new_resource.volume_template) if @new_resource.volume_template
          Chef::Log.info "Creating #{@resource_name} '#{properties['name']}' from snapshot #{snapshot_name}"
          @context.converge_by "Created #{@resource_name} '#{properties['name']}' from snapshot #{snapshot_name}" do
            @item.create_from_snapshot(snapshot_name, properties, volume_template, @new_resource.is_permanent)
          end
        end

        def add_or_edit
          validate_required_properties(:storage_system, :device_volume_name, :is_shareable)
          options = Marshal.load(Marshal.dump(@item.data))
          return Chef::Log.info "#{@resource_name} '#{@name}' already exists" if @item.exists?
          storage_system = resource_named(:StorageSystem).new(@item.client, name: @new_resource.storage_system)
          Chef::Log.info "Adding #{@resource_name} '#{@name}'"
          @context.converge_by "Added #{@resource_name} '#{@name}'" do
            resource_named(:Volume).add(@item.client, storage_system, @new_resource.device_volume_name, @new_resource.is_shareable, options)
          end
        end

        # Delete the OneView resource if it exists
        # @param [Symbol] method Delete or remove method
        # @return [TrueClass, FalseClass] Returns true if the resource was deleted/removed
        def delete
          return false unless @item.retrieve!
          flag = @new_resource.delete_only_appliance ? :oneview : :all
          msg = @new_resource.delete_only_appliance ? 'only' : 'and the storage system'
          Chef::Log.info "Deleting #{@resource_name} '#{@name}' from appliance #{msg}"
          @context.converge_by "Deleted #{@resource_name} '#{@name}' from appliance #{msg}" do
            @item.delete(flag)
          end
          true
        end

        def set_properties
          @item['properties'] ||= {}
          @item['isPermanent'] ||= @new_resource.is_permanent
          @item['properties']['name'] = @new_resource.name
          @item['properties']['description'] ||= @item['description'] if @item['description']
          @item['properties']['storagePool'] ||= @item['storagePoolUri'] if @item['storagePoolUri']
          @item['properties']['snapshotPool'] ||= @item['snapshotPoolUri'] if @item['snapshotPoolUri']
          @item['properties']['provisioningType'] ||= @item['provisioningType'] if @item['provisioningType']
          @item['properties']['size'] ||= @item['size'] if @item['size']
          @item['properties']['dataProtectionLevel'] ||= @item['dataProtectionLevel'] if @item['dataProtectionLevel']
          @item['properties']['isShareable'] ||= @item['isShareable'] || @new_resource.is_shareable if @item['isShareable']
          attrs = ['name', 'description', 'storagePool', 'provisioningType', 'size', 'isShareable', 'dataProtectionLevel', 'storagePoolUri', 'snapshotPoolUri']
          attrs.each { |attr| @item.data.delete(attr) } unless @item['properties'].empty?
          @item.data.delete('properties') if @item['properties'].empty?
        end
      end
    end
  end
end
