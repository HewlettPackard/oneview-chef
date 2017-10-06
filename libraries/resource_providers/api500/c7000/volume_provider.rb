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
            storage_system_uri = load_resource(:StorageSystem, { hostname: @new_resource.storage_system, name: @new_resource.storage_system }, 'uri')
            @item.set_storage_pool(resource_named(:StoragePool).new(@item.client, name: @new_resource.storage_pool, storageSystemUri: storage_system_uri))
            @item.set_snapshot_pool(resource_named(:StoragePool).new(@item.client, name: @new_resource.snapshot_pool, storageSystemUri: storage_system_uri)) if @new_resource.snapshot_pool
          end
          @item['properties']['name'] = @new_resource.name
          @item.exists? ? @item.data.delete('properties') : set_properties
        end

        def load_volume_template
          template = resource_named(:VolumeTemplate).new(@item.client, name: @new_resource.volume_template)
          @item.set_storage_volume_template(template)
          @item.set_storage_pool(resource_named(:StoragePool).new(@item.client, uri: template['storagePoolUri']))
          @item.set_snapshot_pool(resource_named(:StoragePool).new(@item.client, uri: template['properties']['snapshotPool']['default'])) if template['family'] == 'StoreServ'
        end

        def create_from_snapshot
          validate_required_properties(:properties)
          raise("#{@resource_name} '#{@name}' not found!") unless @item.retrieve!
          properties = convert_keys(@new_resource.properties, :to_s)
          return Chef::Log.info "Volume '#{properties['name']}' already exists" if resource_named(:Volume).new(@item.client, name: properties['name']).exists?
          snapshot_name = properties['snapshotName']
          properties.delete('snapshotName')
          volume_template = nil
          volume_template = resource_named(:VolumeTemplate).new(@item.client, name: @new_resource.volume_template) if @new_resource.volume_template
          Chef::Log.info "Creating #{@resource_name} '#{properties['name']}' from snapshot #{snapshot_name}"
          @context.converge_by "Created #{@resource_name} '#{properties['name']}' from snapshot #{snapshot_name}" do
            @item.create_from_snapshot(snapshot_name, properties, volume_template, @new_resource.is_permanent)
          end
        end

        def add_if_missing
          validate_required_properties(:storage_system) unless @item['storageSystemUri']
          return Chef::Log.info("#{@resource_name} '#{@name}' already exists.") if @item.exists?
          @item['storageSystemUri'] ||= load_resource(:StorageSystem, { hostname: @new_resource.storage_system, name: @new_resource.storage_system }, 'uri')
          @item['deviceVolumeName'] ||= @name
          Chef::Log.info "Adding #{@resource_name} '#{@name}'"
          @context.converge_by "Added #{@resource_name} '#{@name}'" do
            @item.add
          end
        end

        # Delete the OneView resource if it exists
        # @param [Symbol] method Delete or remove method
        # @return [TrueClass, FalseClass] Returns true if the resource was deleted/removed
        def delete
          return false unless @item.retrieve!
          flag = @new_resource.delete_from_appliance_only ? :oneview : :all
          msg = @new_resource.delete_from_appliance_only ? 'only' : 'and the storage system'
          Chef::Log.info "Deleting #{@resource_name} '#{@name}' from appliance #{msg}"
          @context.converge_by "Deleted #{@resource_name} '#{@name}' from appliance #{msg}" do
            @item.delete(flag)
          end
          true
        end

        def set_properties
          @item['isPermanent'] ||= @new_resource.is_permanent
          @item['properties']['description'] ||= @item['description']
          @item['properties']['provisioningType'] ||= @item['provisioningType']
          @item['properties']['size'] ||= @item['size']
          @item['properties']['dataProtectionLevel'] ||= @item['dataProtectionLevel'] if @item['dataProtectionLevel']
          @item['properties']['isShareable'] ||= @item['isShareable']
          attrs = ['name', 'description', 'storagePool', 'provisioningType', 'size', 'isShareable', 'dataProtectionLevel', 'storagePoolUri', 'snapshotPoolUri']
          attrs.each { |attr| @item.data.delete(attr) }
        end
      end
    end
  end
end
