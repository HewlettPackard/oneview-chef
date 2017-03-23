# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
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
    # EthernetNetworkProvider
    class EthernetNetworkProvider < ResourceProvider
      def create_or_update
        bandwidth = @item.data.delete('bandwidth')
        super
        update_connection_template(bandwidth: bandwidth) if bandwidth
      end

      def create_if_missing
        bandwidth = @item.data.delete('bandwidth')
        created = super
        update_connection_template(bandwidth: bandwidth) if bandwidth && created
      end

      def update_connection_template(bandwidth)
        bandwidth = convert_keys(bandwidth, :to_s)
        connection_template = load_resource(:ConnectionTemplate, uri: @item['connectionTemplateUri'])
        if connection_template.like? bandwidth
          Chef::Log.info("#{@resource_name} '#{@name}' connection template is up to date")
        else
          diff = get_diff(connection_template, bandwidth)
          diff.insert(0, '. Diff:') unless diff.to_s.empty?
          Chef::Log.info "Updating #{@resource_name} '#{@name}' connection template settings#{diff}"
          @context.converge_by "Update #{@resource_name} '#{@name}' connection template settings" do
            connection_template.update(bandwidth)
          end
        end
      end

      def reset_connection_template
        @item.retrieve!
        klass = resource_named(:ConnectionTemplate)
        update_connection_template(bandwidth: klass.get_default(@item.client)['bandwidth'])
      end
    end
  end
end
