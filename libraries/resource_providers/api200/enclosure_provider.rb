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
    # Enclosure API200 provider
    class EnclosureProvider < ResourceProvider
      def add_or_edit
        if @context.enclosure_group
          eg = resource_named(:EnclosureGroup).new(@item.client, name: @context.enclosure_group)
          @item.set_enclosure_group(eg)
        end
        super
      end

      def reconfigure
        @item.retrieve!
        if ['NotReapplyingConfiguration', 'ReapplyingConfigurationFailed', ''].include? @item['reconfigurationState']
          @context.converge_by "#{@resource_name} '#{@name}' was reconfigured." do
            @item.configuration
          end
        else
          Chef::Log.info("#{@resource_name} '#{@name}' configuration is already running. State: #{@item['reconfigurationState']}")
        end
      end

      def refresh
        @item.retrieve!
        refresh_ready = ['RefreshFailed', 'NotRefreshing', ''].include? @item['refreshState']
        return Chef::Log.info("#{@resource_name} '#{@name}' refresh is already running. State: #{@item['refreshState']}") unless refresh_ready
        @context.converge_by "#{@resource_name} '#{@name}' was refreshed." do
          @item.set_refresh_state(@context.state, @context.options)
        end
      end

      # Sends the following operations to the Enclosure hardware
      # Set the appliance bay power state on - operation: replace; path: /applianceBays/[1,2]/power; values: On
      # Set the UID for the enclosure - operation: replace; path: /uidState; values: On|Off
      # Set the UID for the Synergy Frame Link Module - operation: replace; path: /managerBays/[1,2]/uidState; values: On|Off
      # Change the name of the enclosure - operation: replace; path: /name; values: new enclosure name
      # Change the name of the rack - operation: replace; path: /rackName; values: new rack name
      # E-Fuse or Reset the Synergy Frame Link Module bay in the path - operation: replace; path: /managerBays/[1,2]/bayPowerState;
      #   values: E-Fuse|Reset
      # E-Fuse the appliance bay in the path - operation: replace; path: /applianceBays/[1,2]/bayPowerState; values: E-Fuse
      # E-Fuse or Reset the device bay in the path - operation: replace; path: /deviceBays/[1-#blades_in_enclosure]/bayPowerState;
      #   values: E-Fuse|Reset
      # E-Fuse the IC bay in the path - operation: replace; path: /interconnectBays/[1-8]/bayPowerState; values: E-Fuse
      # Set the active Synergy Frame Link Module - operation: replace; path: /managerBays/[1,2]/role; values: active
      # Release IPv4 address in the path - operation: remove; path: /deviceBays/[1-12]/ipv4Setting
      # Release IPv4 address in the path - operation: remove; path: /interconnectBays/[1-6]/ipv4Setting
      # Add one scopeUri to the enclosure - operation: add; path: /scopeUris/-|/scopeUris/[0-#index_of_scopes_on_current_enclosure]; values: scopeUri
      # Remove one scopeUri from the enclosure - operation: remove; path: /scopeUris/[0-#index_of_scopes_on_current_enclosure]
      # Change the scopeUris of the enclosure - operation: replace; path: /scopeUris; values: a list of scopeUris
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
