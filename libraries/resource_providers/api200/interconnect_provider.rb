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
    # Interconnect API200 provider
    class InterconnectProvider < ResourceProvider
      include OneviewCookbook::PatchOperations::OnOff
      include OneviewCookbook::PatchOperations::Reset

      def reset
        reset_handler('/deviceResetState')
      end

      def reset_port_protection
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        # Nothing to verify
        @context.converge_by "Reset #{@resource_name} '#{@name}' port protection" do
          @item.reset_port_protection
        end
      end

      def update_port
        raise "Unspecified property: 'port_options'. Please set it before attempting this action." unless @new_resource.port_options
        parsed_port_options = convert_keys(@new_resource.port_options, :to_s)
        raise "Required value \"name\" for 'port_options' not specified" unless parsed_port_options['name']
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        target_port = (@item['ports'].select { |port| port['name'] == parsed_port_options['name'] }).first
        raise "Could not find port: #{parsed_port_options['name']}" unless target_port
        # Update only if there are options that differ from the current ones
        if parsed_port_options.any? { |k, v| target_port[k] != v }
          diff = get_diff(target_port, parsed_port_options)
          Chef::Log.info "Updating #{@resource_name} '#{@name}'#{diff}"
          @context.converge_by "Update #{@resource_name} '#{@name}' port #{parsed_port_options['name']}" do
            @item.update_port(parsed_port_options['name'], parsed_port_options)
          end
        else
          Chef::Log.info("#{@resource_name} '#{@name}' port #{parsed_port_options['name']} is up to date.")
        end
      end
    end
  end
end
