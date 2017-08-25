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
    # ManagedSAN API200 provider
    class ManagedSANProvider < ResourceProvider
      def refresh
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        refresh_ready = ['RefreshFailed', 'NotRefreshing', ''].include? @item['refreshState']
        return Chef::Log.info("#{@resource_name} '#{@name}' refresh is already running. State: #{@item['refreshState']}") unless refresh_ready
        @context.converge_by "#{@resource_name} '#{@name}' was refreshed." do
          @item.set_refresh_state(@new_resource.refresh_state)
        end
      end

      def set_policy
        temp = Marshal.load(Marshal.dump(@item['sanPolicy']))
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        return Chef::Log.info "#{@resource_name} '#{@name}' san policy is up to date" if temp.all? { |k, v| v == @item['sanPolicy'][k] }
        Chef::Log.info "Updating #{@resource_name} '#{@name}' san policy"
        @context.converge_by "#{@resource_name} '#{@name}' san policy updated" do
          @item.set_san_policy(temp)
        end
      end

      def set_public_attributes
        temp_attributes = Marshal.load(Marshal.dump(@item['publicAttributes']))
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        # compares two hashes
        results = (temp_attributes - @item['publicAttributes']) + (@item['publicAttributes'] - temp_attributes)
        return Chef::Log.info "#{@resource_name} '#{@name}' public attributes are up to date" if results.empty?
        Chef::Log.info "Updating #{@resource_name} '#{@name}' public attributes"
        @context.converge_by "#{@resource_name} '#{@name}' public attributes updated" do
          @item.set_public_attributes(temp_attributes)
        end
      end
    end
  end
end
