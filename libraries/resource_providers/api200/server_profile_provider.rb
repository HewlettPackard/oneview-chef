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
    # Helper module for
    module ServerProfileProviderHelpers
      def set_connections(type, connection_list)
        return false unless connection_list
        # Is a Hash-like or an Array of Hash-like objects
        is_hashy = connection_list.respond_to?(:keys)
        is_hashy_array = connection_list.respond_to?(:first) && connection_list.first.respond_to?(:keys)
        if is_hashy
          connection_list.each { |net_name, options| @item.add_connection(load_resource(type, net_name), options) }
        elsif is_hashy_array
          connection_list.each do |c|
            c.map { |net_name, options| @item.add_connection(load_resource(type, net_name), options) }
          end
        else
          raise(StandardError, "Invalid #{type} connection list: #{connection_list}")
        end
        true
      end

      def build_volume_attachments
        @new_resource.volume_attachments.each do |options|
          options = convert_keys(options, :to_s)
          volume_name = options['volume']
          volume_data = options['volume_data']
          attachment_data = options.fetch('attachment_data', {})
          raise("To add volume attachments you need to specify the 'volume' or 'volume_data' inside 'volume_attachments' options") unless volume_name || volume_data
          if volume_name
            volume = load_resource(:Volume, name: volume_name)
            @item.add_volume_attachment(volume, attachment_data)
          else
            storage_system_name = options.delete('storage_system')
            storage_pool_name = options.delete('storage_pool')
            can_create_volume = storage_system_name && storage_pool_name
            raise("To create a new volume with an attachment you need to specify the 'storage_system' and 'storage_pool' names inside 'volume_attachments' options.") unless can_create_volume
            storage_system_uri = load_resource(:StorageSystem, { hostname: storage_system_name, name: storage_system_name }, :uri)
            storage_pool = load_resource(:StoragePool, name: storage_pool_name, storageSystemUri: storage_system_uri)
            @item.create_volume_with_attachment(storage_pool, volume_data, attachment_data)
          end
          @item['sanStorage']['hostOSType'] = options['host_os_type']
        end
      end

      def set_resource(type, name, method, args = [])
        return false unless name
        @item.public_send(method, load_resource(type, name), *args)
        true
      end
    end

    # ServerProfile API200 provider
    class ServerProfileProvider < ResourceProvider
      include ServerProfileProviderHelpers
      # Loads the Server profile with all the external resources (if needed)
      def load_with_properties
        set_resource(:ServerHardware, @new_resource.server_hardware, :set_server_hardware)
        set_resource(:ServerHardwareType, @new_resource.server_hardware_type, :set_server_hardware_type)
        set_resource(:EnclosureGroup, @new_resource.enclosure_group, :set_enclosure_group)
        set_resource(:Enclosure, @new_resource.enclosure, :set_enclosure)
        set_resource(:FirmwareDriver, @new_resource.firmware_driver, :set_firmware_driver)
        set_connections(:EthernetNetwork, @new_resource.ethernet_network_connections)
        set_connections(:FCNetwork, @new_resource.fc_network_connections)
        set_connections(:FCoENetwork, @new_resource.fcoe_network_connections)
        set_connections(:NetworkSet, @new_resource.network_set_connections)
        build_volume_attachments
      end

      # Override create method to allow creation from a template
      def create(method)
        if @new_resource.server_profile_template
          template = load_resource(:ServerProfileTemplate, @new_resource.server_profile_template)
          Chef::Log.info "Using template '#{@new_resource.server_profile_template}' to #{method} #{@resource_name} '#{@name}'"
          new_profile_data = template.new_profile(@item['name']).data
          @item.data = new_profile_data.merge(@item.data)
        end
        super
      end

      def create_or_update
        load_with_properties
        super
      end

      def create_if_missing
        load_with_properties
        super
      end

      def update_from_template
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        if @item['templateCompliance'] == 'Compliant'
          Chef::Log.info("#{@resource_name} '#{@item['name']}' is up to date")
        else
          preview = JSON.pretty_generate(@item.get_compliance_preview) rescue 'ERROR: Failed to retrieve compliance preview.'
          Chef::Log.info "Updating #{@resource_name} '#{@item['name']}' from template. Compliance Preview: #{preview}"
          @context.converge_by "Update #{@resource_name} '#{@item['name']}' from template" do
            @item.update_from_template
          end
        end
      end
    end
  end
end
