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

require_relative 'interconnect_provider'

module OneviewCookbook
  module API200
    # Interconnect API200 provider
    class SASInterconnectProvider < InterconnectProvider
      def reset
        reset_handler('softReset/')
      end

      def hard_reset
        reset_handler('hardReset/')
      end

      def refresh
        @item.retrieve!
        refresh_ready = ['RefreshFailed', 'NotRefreshing', ''].include? @item['refreshState']
        return Chef::Log.info("#{@resource_name} '#{@name}' refresh is already running. State: #{@item['refreshState']}") unless refresh_ready
        @context.converge_by "#{@resource_name} '#{@name}' was refreshed." do
          @item.set_refresh_state(@context.state)
        end
      end

      protected

      def reset_handler(path)
        @item.retrieve!
        # Nothing to verify
        @context.converge_by "#{path.delete('/').gsub(/([A-Z])/, ' \1').capitalize} #{@resource_name} '#{@name}'" do
          @item.patch('replace', path, 'Reset')
        end
      end

      private

      def update_port
        Chef::Log.error('InternalError: Method not supported by this resource')
      end

      def reset_port_protection
        Chef::Log.error('InternalError: Method not supported by this resource')
      end
    end
  end
end
