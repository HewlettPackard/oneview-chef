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
    # ManagedSAN API200 provider
    class ManagedSANProvider < ResourceProvider
      def set_refresh_state
        temp = @item['refreshState']
        raise "Resource not found: #{@resource_name} '#{@item['name']}'" unless @item.exists?

        @item.retrieve!
        if @item['refreshState'] != temp
          Chef::Log.info "Refreshing #{@resource_name} '#{@name}'"
          @context.converge_by "#{@resource_name} '#{@name}' refreshed" do
            @item.set_refresh_state(temp)
          end
        else
          Chef::Log.info "#{@resource_name} '#{@name}' is already #{temp}"
        end
      end

      def set_policy
        temp = Marshal.load(Marshal.dump(@item['sanPolicy']))
        raise "Resource not found: #{@resource_name} '#{@item['name']}'" unless @item.exists?

        @item.retrieve!
        if temp.all? { |k, v| v == @item['sanPolicy'][k] }
          Chef::Log.info "#{@resource_name} '#{@name}' san policy is up to date"
        else
          Chef::Log.info "Updating #{@resource_name} '#{@name}' san policy"
          @context.converge_by "#{@resource_name} '#{@name}' san policy updated" do
            @item.set_san_policy(temp)
          end
        end
      end

      def set_public_attributes
        temp = Marshal.load(Marshal.dump(@item['publicAttributes']))
        raise "Resource not found: #{@resource_name} '#{@item['name']}'" unless @item.exists?

        @item.retrieve!
        # compares two hashes
        results = []
        temp_attributes = temp.sort_by { |element| element['name'] }
        item_attributes = @item['publicAttributes'].sort_by { |element| element['name'] }

        temp_attributes = temp_attributes.each_with_index do |element, index|
          results << element.all? { |k, v| v == item_attributes[index][k] }
        end

        if results.all?
          Chef::Log.info "#{@resource_name} '#{@name}' public attributes are up to date"
        else
          Chef::Log.info "Updating #{@resource_name} '#{@name}' public attributes"
          @context.converge_by "#{@resource_name} '#{@name}' public attributes updated" do
            @item.set_public_attributes(temp_attributes)
          end
        end
      end
    end
  end
end
