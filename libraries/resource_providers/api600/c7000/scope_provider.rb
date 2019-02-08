# (c) Copyright 2018 Hewlett Packard Enterprise Development LP
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
  module API600
    module C7000
      # Scope API600 C7000 provider
      class ScopeProvider < OneviewCookbook::API500::C7000::ScopeProvider
        def replace_resource_scopes_assignments
          return Chef::Log.info('No scopes were specified to perform replace_scopes. Skipping') if @new_resource.scopes.nil?
          replace = @new_resource.replace.any?
          raise "Unspecified property: 'replace'. Please set replace property before attempting this action." unless replace
          client = OneviewCookbook::Helper.build_client(@new_resource.client)
          context = @new_resource.replace
          context.each do |resource_name, values|
            values.each do |value|
              retrieved_resource = load_resource(resource_name, value)
              scopes = @new_resource.scopes.map { |scope_name| load_resource(:Scope, scope_name) }
              Chef::Log.info "Performing resource assignments on #{@resource_name}"
              @context.converge_by "Performed resource assignments on #{@resource_name}" do
                resource_named(:Scope).replace_resource_assigned_scopes(client, retrieved_resource, scopes: scopes)
              end
            end
          end
        end

        def modify_resource_scopes_assignments
          return Chef::Log.info('No resource were specified to modify resource scopes. Skipping') if @new_resource.resource.nil?
          add_or_remove = @new_resource.add.any? || @new_resource.remove.any?
          raise "Unspecified properties: 'add' and 'remove'. Please set at least one before attempting this action." unless add_or_remove
          client = OneviewCookbook::Helper.build_client(@new_resource.client)
          scopes_to_add = build_scope_list
          scopes_to_remove = build_scope_list(:remove)
          return Chef::Log.info("#{@resource_name} '#{@name}' is up to date") if scopes_to_add.empty? && scopes_to_remove.empty?
          diff = ''
          diff << "\n  Adding: #{JSON.pretty_generate(scopes_to_add)}" unless scopes_to_add.empty?
          diff << "\n  Removing: #{JSON.pretty_generate(scopes_to_remove)}" unless scopes_to_remove.empty?

          context = @new_resource.resource
          context.each do |resource_name, values|
            values.each do |value|
              retrieved_resource = load_resource(resource_name, value)
              diff << "\n  Resource: #{JSON.pretty_generate(retrieved_resource['uri'])}" unless retrieved_resource.nil?
              Chef::Log.info "Performing resource assignments on #{@resource_name}:#{diff}"
              @context.converge_by "Performed resource assignments on #{@resource_name}" do
                resource_named(:Scope).resource_patch(client, retrieved_resource, add_scopes: scopes_to_add, remove_scopes: scopes_to_remove)
              end
            end
          end
        end

        def build_scope_list(op = :add)
          retrieved_scopes = []
          context = op == :add ? @new_resource.add : @new_resource.remove
          context.each do |resource_name, values|
            values.each do |value|
              retrieved_scope = load_resource(resource_name, value)
              retrieved_scopes.push(retrieved_scope)
            end
          end
          retrieved_scopes
        end
      end
    end
  end
end
