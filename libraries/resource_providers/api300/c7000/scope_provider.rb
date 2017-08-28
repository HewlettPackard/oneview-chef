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
  module API300
    module C7000
      # Scope API300 C7000 provider methods
      class ScopeProvider < ResourceProvider
        # Adds or removes resources to a specified scope
        # @note Calls the build_resource_list method to retrieve the resources
        def change_resource_assignments
          add_or_remove = @new_resource.add.any? || @new_resource.remove.any?
          raise "Unspecified properties: 'add' and 'remove'. Please set at least one before attempting this action." unless add_or_remove
          @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
          values_to_add = build_resource_list
          values_to_remove = build_resource_list(:remove)
          return Chef::Log.info("#{@resource_name} '#{@name}' is up to date") if values_to_add.empty? && values_to_remove.empty?
          diff = ''
          diff << "\n  Adding: #{JSON.pretty_generate(values_to_add)}" unless values_to_add.empty?
          diff << "\n  Removing: #{JSON.pretty_generate(values_to_remove)}" unless values_to_remove.empty?
          Chef::Log.info "Performing resource assignments on #{@resource_name} '#{@item['name']}':#{diff}"
          @context.converge_by "Performed resource assignments on #{@resource_name} '#{@item['name']}'" do
            @item.change_resource_assignments(add_resources: values_to_add, remove_resources: values_to_remove)
          end
        end

        # Retrieves the resources listed on the add or remove fields and creates an array with their instances
        # @return [Array] containing the instances of all resources to be added or removed
        def build_resource_list(op = :add)
          retrieved_resources = []
          context = op == :add ? @new_resource.add : @new_resource.remove
          context.each do |resource_name, values|
            values.each do |value|
              retrieved_resource = load_resource(resource_name, value)
              is_scope_present = retrieved_resource['scopeUris'].include?(@item['uri'])
              next if (op == :add && is_scope_present) || (op == :remove && !is_scope_present)
              retrieved_resources.push(retrieved_resource)
            end
          end
          retrieved_resources
        end
      end
    end
  end
end
