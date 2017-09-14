# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewCookbook
  # module for actions related to refresh of resource
  module RefreshActions
    # module SetRefreshState with method to refresh calling set_refresh_state method of resource
    module SetRefreshState
      def refresh
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        refresh_ready = ['RefreshFailed', 'NotRefreshing', ''].include? @item['refreshState']
        return Chef::Log.info("#{@resource_name} '#{@name}' refresh is already running. State: #{@item['refreshState']}") unless refresh_ready
        state_value = @new_resource.refresh_state if @new_resource.respond_to?(:refresh_state)
        state_value ||= 'RefreshPending'
        @context.converge_by "#{@resource_name} '#{@name}' was refreshed." do
          if @new_resource.respond_to?(:refresh_options)
            @item.set_refresh_state(state_value, @new_resource.refresh_options)
          else
            @item.set_refresh_state(state_value)
          end
        end
      end
    end

    # module RequestRefresh with method to refresh calling request_refresh method of resource
    module RequestRefresh
      def refresh
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        @context.converge_by "#{@resource_name} '#{@name}' was refreshed." do
          @item.request_refresh
        end
      end
    end
  end
end
