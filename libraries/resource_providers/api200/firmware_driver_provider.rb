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

require_relative '../../resource_provider'

module OneviewCookbook
  module API200
    # Firmware API200 provider
    class FirmwareDriverProvider < ResourceProvider
      def load_firmware(filename = nil)
        return @item if @item.retrieve!
        filename ||= @name
        filename = ::File.basename(filename, ::File.extname(filename)).tr('.', '_')
        firmware_list = resource_named(:FirmwareDriver).find_by(@item.client, {})
        firmware_list.find { |fw| filename == fw['resourceId'] }
      end

      def add_or_edit
        client = @item.client
        @item = load_firmware
        return Chef::Log.info "#{@resource_name} '#{@name}' is already up to date." if @item
        @context.converge_by "Add #{@resource_name} '#{@name}'" do
          version = OneviewSDK.const_get("API#{@sdk_api_version}")
          version = version.const_get(@sdk_api_variant) if @sdk_api_variant
          version.const_get(:FirmwareBundle).add(client, @name)
        end
      end

      def create_custom_spp
        hotfix_present = @context.hotfixes_names || @context.hotfixes_files
        raise "Unspecified property: 'hotfixes_names' or 'hotfixes_files'. Please set it before attempting this action." unless hotfix_present

        spp_present = @context.spp_name || @context.spp_file
        raise "Unspecified property: 'spp_name' or 'spp_file'. Please set it before attempting this action." unless spp_present

        return Chef::Log.info "#{@resource_name} '#{@name}' is already up to date." if @item.exists?

        load_spp
        load_hotfixes

        @item['customBaselineName'] = @name
        Chef::Log.info "Created custom #{@resource_name} '#{@name}'"
        @context.converge_by "Created custom #{@resource_name} '#{@name}'" do
          @item.data.delete('name')
          @item.create
        end
      end

      # Verifies and loads the SPP
      def load_spp
        spp = nil
        fd_klass = resource_named(:FirmwareDriver)
        if @context.spp_name
          spp = fd_klass.new(@item.client, name: @context.spp_name)
          spp.retrieve!
        elsif @context.spp_file
          spp = load_firmware(@context.spp_file)
        end
        @item['baselineUri'] = spp['uri']
      end

      # Verifies and loads Hotfixes
      def load_hotfixes
        @item['hotfixUris'] = []
        fd_klass = resource_named(:FirmwareDriver)
        if @context.hotfixes_names
          @context.hotfixes_names.each do |hotfix|
            temp = fd_klass.new(@item.client, name: hotfix)
            temp.retrieve!
            @item['hotfixUris'] << temp['uri'] if temp['uri']
          end
        elsif @context.hotfixes_files
          @context.hotfixes_files.each do |hotfix|
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
