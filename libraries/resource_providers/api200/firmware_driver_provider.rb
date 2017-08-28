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
    # Firmware API200 provider
    class FirmwareDriverProvider < ResourceProvider
      def load_firmware(filename = nil)
        return @item if @item.retrieve!
        filename ||= @name
        filename = ::File.basename(filename, ::File.extname(filename)).tr('.', '_')
        firmware_list = resource_named(:FirmwareDriver).get_all(@item.client)
        firmware_list.find { |fw| filename == fw['resourceId'] }
      end

      def add_or_edit
        client = @item.client
        @item = load_firmware
        return Chef::Log.info "#{@resource_name} '#{@name}' is already up to date." if @item
        Chef::Log.info "Adding #{@resource_name} '#{@name}'. This may take some time..."
        @context.converge_by "Add #{@resource_name} '#{@name}'" do
          resource_named(:FirmwareBundle).add(client, @name)
        end
      end

      def create_custom_spp
        hotfix_present = @new_resource.hotfixes_names || @new_resource.hotfixes_files
        raise "Unspecified property: 'hotfixes_names' or 'hotfixes_files'. Please set it before attempting this action." unless hotfix_present

        spp_present = @new_resource.spp_name || @new_resource.spp_file
        raise "Unspecified property: 'spp_name' or 'spp_file'. Please set it before attempting this action." unless spp_present

        return Chef::Log.info "#{@resource_name} '#{@name}' is already up to date." if @item.exists?

        load_spp
        load_hotfixes

        @item['customBaselineName'] = @name
        Chef::Log.info "Creating custom #{@resource_name} '#{@name}'"
        @context.converge_by "Create custom #{@resource_name} '#{@name}'" do
          @item.data.delete('name')
          @item.create
        end
      end

      # Verifies and loads the SPP
      def load_spp
        spp = nil
        if @new_resource.spp_name
          spp = load_resource(:FirmwareDriver, @new_resource.spp_name)
        elsif @new_resource.spp_file
          spp = load_firmware(@new_resource.spp_file)
        else
          raise "InvalidProperties: The property 'spp_name' or 'spp_file' must be specified."
        end
        @item['baselineUri'] = spp['uri']
      end

      # Verifies and loads Hotfixes
      def load_hotfixes
        @item['hotfixUris'] = []
        if @new_resource.hotfixes_names
          @new_resource.hotfixes_names.each { |hotfix| @item['hotfixUris'] << load_resource(:FirmwareDriver, hotfix, 'uri') }
        elsif @new_resource.hotfixes_files
          @new_resource.hotfixes_files.each do |hotfix|
            temp = load_firmware(hotfix)
            @item['hotfixUris'] << temp['uri'] if temp['uri']
          end
        end
      end

      def remove
        @item = load_firmware
        return Chef::Log.info "#{@resource_name} '#{@name}' is already up to date." unless @item
        super
      end
    end
  end
end
