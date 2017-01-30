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
    # ServerHardware API200 provider
    class ServerHardwareProvider < ResourceProvider
      def update_ilo_firmware
        @item.retrieve!
        @context.converge_by "Updating iLO firmware on #{@resource_name} '#{@item['name']}'" do
          @item.update_ilo_firmware
        end
      end

      def set_power_state
        raise "Unspecified property: 'power_state'. Please set it before attempting this action." unless @context.power_state
        ps = @context.power_state.to_s.downcase
        raise "#{@resource_name} '#{@item['name']}' not found!" unless @item.retrieve!
        if @item['powerState'].casecmp(ps).zero?
          Chef::Log.info("#{@resource_name} '#{@item['name']}' is already powered #{ps}")
        else
          @context.converge_by "Power #{ps} #{@resource_name} '#{@item['name']}'" do
            @item.public_send("power_#{ps}".to_sym)
          end
        end
      end

      def refresh
        raise "#{@resource_name} '#{@item['name']}' not found!" unless @item.retrieve!
        refresh_ready = ['RefreshFailed', 'NotRefreshing', ''].include? @item['refreshState']
        return Chef::Log.info("#{@resource_name} '#{@item['name']}' refresh is already running.") unless refresh_ready
        @context.converge_by "Refresh #{@resource_name} '#{@item['name']}'." do
          @item.set_refresh_state('RefreshPending', @context.refresh_options)
        end
      end

      # Description                         ||  Operation  ||  Path      ||  Value
      # Reset iLO state                      |  replace    |  /mpState   |  Reset
      # Set the server UID state on          |  replace    |  /uidState  |  On
      # Set the server UID state off         |  replace    |  /uidState  |  Off
      # Add one scopeUri to the server       |  add        |  /scopeUris/-|/scopeUris/[0-#index_of_scopes_on_current_server]  |  scopeUri
      # Change the scopeUris of the server   |  replace    |  /scopeUris  |  a list of scopeUris
      # Remove one scopeUri from the server  |  remove     |  /scopeUris/[0-#index_of_scopes_on_current_server]
      def patch
        invalid_param = @context.operation.nil? || @context.path.nil?
        raise "InvalidParameters: Parameters 'operation' and 'path' must be set for patch" if invalid_param
        # TODO: Add support to Scopes (Currently not supported by oneview-sdk gem 3.1.0)
        @item.retrieve!
        @context.converge_by "Performing '#{@context.operation}' at #{@context.path} with #{@context.value} in #{@resource_name} '#{@name}'" do
          @item.patch(@context.operation, @context.path, @context.value)
        end
      end
    end
  end
end
