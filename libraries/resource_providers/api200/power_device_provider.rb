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
    # PowerDevice API200 provider
    class PowerDeviceProvider < ResourceProvider
      def discover
        pd_klass = resource_named(:PowerDevice)
        power_devices_list = pd_klass.get_ipdu_devices(@item.client, @name)
        return Chef::Log.info("#{@resource_name} '#{@name}' is up to date") unless power_devices_list.empty?
        Chef::Log.info "Discovering #{@resource_name} '#{@name}'"
        @context.converge_by "Discovered #{@resource_name} '#{@name}'" do
          begin
            pd_klass.discover(@item.client, hostname: @name, username: @new_resource.username, password: @new_resource.password)
          rescue OneviewSDK::OneViewError => error
            raise error unless @new_resource.auto_import_certificate && error.message.include?('Unable to retrieve the input certificate')
            Chef::Log.warn("Oneview returned the following error:\n #{error.message}")
            Chef::Log.info("Trying to automatically import certificate for #{@resource_name} '#{@name}'")
            import_certificate_for_ipdu
            pd_klass.discover(@item.client, hostname: @name, username: @new_resource.username, password: @new_resource.password)
          end
        end
      end

      def load_power_device
        return @item if @item.retrieve!
        power_devices_list = resource_named(:PowerDevice).get_ipdu_devices(@item.client, @name)
        power_devices_list.first
      end

      def remove
        # First try to remove by name, if it does not work it consider the power device is an iPDU
        return true if super
        item = load_power_device
        return false if item.nil?
        @item = item
        super
      end

      def refresh
        @item = load_power_device || raise("#{@resource_name} '#{@name}' not found!")
        raise "Unspecified property: 'refresh_options'. Please set it before attempting this action." unless @new_resource.refresh_options
        refresh_ready = ['RefreshFailed', 'NotRefreshing', ''].include? @item['refreshState']
        return Chef::Log.info("#{@resource_name} '#{@name}' refresh is already running. State: #{@item['refreshState']}") unless refresh_ready
        @context.converge_by "#{@resource_name} '#{@name}' was refreshed." do
          @item.set_refresh_state(@new_resource.refresh_options)
        end
      end

      def set_uid_state
        execute_action_to_set_property(:uid_state)
      end

      def set_power_state
        execute_action_to_set_property(:power_state)
      end

      private

      # method to help to set property power_state or uid_state, applying the DRY concept
      def execute_action_to_set_property(property_name)
        @item = load_power_device || raise("#{@resource_name} '#{@name}' not found!")
        raise "Unspecified property: '#{property_name}'. Please set it before attempting this action." unless @new_resource.send(property_name)
        property_name = property_name.to_s
        current_state = @item.public_send('get_' + property_name)
        desired_value = @new_resource.public_send(property_name).to_s.capitalize
        return Chef::Log.info("The #{property_name} of #{@resource_name} '#{@name}' is already #{desired_value}") if current_state == desired_value
        @context.converge_by "#{@resource_name} '#{@name}' #{property_name} set to #{desired_value}" do
          @item.public_send('set_' + property_name, desired_value)
        end
      end

      def import_certificate_for_ipdu
        Chef::Log.info("Verifying certificate for #{@resource_name} '#{@name}'")
        client_certificate = resource_named(:ClientCertificate).new(@item.client, aliasName: @name)
        return Chef::Log.info("Certificate already imported for #{@resource_name} '#{@name}'") if client_certificate.retrieve!
        web_certificate = resource_named(:WebServerCertificate).get_certificate(@item.client, @name)
        Chef::Log.info("Importing certificate for #{@resource_name} '#{@name}'")
        client_certificate['base64SSLCertData'] = web_certificate['base64Data']
        client_certificate.import
      end
    end
  end
end
