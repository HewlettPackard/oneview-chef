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

require_relative '../../../resource_provider'

module OneviewCookbook
  module API300
    module C7000
      # Scope API300 C7000 provider methods
      class ScopeProvider < ResourceProvider
        # Adds or removes resources to a specified scope
        # @note Calls the parse_resource_values method to retrieve the resources
        # @return [<OneviewSDK::<APIVER>::<VARIANT>::Scope>] with the updated resources
        def change_resource_assignments
          add_or_remove = @context.add.any? || @context.remove.any?
          raise "Unspecified properties: 'add' and 'remove'. Please set at least one before attempting this action." unless add_or_remove
          @item.retrieve!
          values_to_add = parse_resource_values
          values_to_remove = parse_resource_values(:remove)
          return Chef::Log.info("#{@resource_name} '#{@name}' is up to date") if values_to_add.empty? && values_to_remove.empty?
          Chef::Log.debug "Resources to be added: #{JSON.pretty_generate(values_to_add)}" unless values_to_add.empty?
          Chef::Log.debug "Resources to be removed: #{JSON.pretty_generate(values_to_remove)}" unless values_to_remove.empty?
          @context.converge_by "Performing resource assignments on #{@item['name']}" do
            @item.change_resource_assignments(add_resources: values_to_add, remove_resources: values_to_remove)
          end
        end

        # Retrieves the resources listed on the add or remove fields and creates an array with their instances
        # @return [Array] containing the instances of all resources to be added or removed
        def parse_resource_values(op = :add)
          retrieved_resources = []
          context = if op == :add
                      @context.add
                    else
                      @context.remove
                    end
          context.each do |resource_name, values|
            klass = resource_named(resource_name)
            values.each do |value|
              retrieved_resource = klass.new(@item.client, name: value)
              raise "#{klass} resource with name #{value} was not found in the appliance." unless retrieved_resource.retrieve!
              is_scope_present = retrieved_resource['scopeUris'].include?(@item['uri'])
              next if op == :add && is_scope_present
              next if op == :remove && !is_scope_present
              retrieved_resources.push(retrieved_resource)
            end
          end
          retrieved_resources
        end
      end
    end
  end
end
