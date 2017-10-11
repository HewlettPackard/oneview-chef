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

require_relative 'storage_system_provider'

module OneviewCookbook
  module API500
    module C7000
      # StoragePool API500 C7000 provider
      class StoragePoolProvider < API300::C7000::StoragePoolProvider
        include OneviewCookbook::RefreshActions::RequestRefresh

        def refresh
          load_storage_system
          super
        end

        def load_storage_system
          raise("Unspecified property: 'storage_system'. Please set it before attempting this action.") unless @new_resource.storage_system
          @item.set_storage_system(load_resource(:StorageSystem, hostname: @new_resource.storage_system, name: @new_resource.storage_system))
        end

        def update_manage_state(managed)
          managed_text = managed ? 'managed' : 'unmanaged'
          return Chef::Log.info("#{@resource_name} '#{@name}' is already #{managed_text}") if @item['isManaged'] == managed
          @context.converge_by "#{@resource_name} '#{@name}' is now #{managed_text}" do
            @item.manage(managed)
          end
        end

        def add_for_management
          load_storage_system
          @item.retrieve! || raise("Resource not found: The #{@resource_name} '#{@name}' could not be found")
          update_manage_state(true)
        end

        def remove_from_management
          load_storage_system
          @item.retrieve! || raise("Resource not found: The #{@resource_name} '#{@name}' could not be found")
          update_manage_state(false)
        end

        def add_if_missing
          Chef::Log.warn("The #{@resource_name} in API #{@sdk_api_version} variant #{@sdk_variant} cannot perform 'add_if_missing' operation. Performing 'add_for_management' instead...")
          add_for_management
        end

        def remove
          Chef::Log.warn("The #{@resource_name} in API #{@sdk_api_version} variant #{@sdk_variant} cannot perform 'remove' operation. Performing 'remove_from_management' instead...")
          remove_from_management
        end

        def update
          load_storage_system
          desired_state = Marshal.load(Marshal.dump(@item.data))
          @item.retrieve! || raise("Resource not found: The #{@resource_name} '#{@name}' could not be found")
          update_manage_state(desired_state['isManaged']) unless desired_state['isManaged'].nil?
          return Chef::Log.info("#{@resource_name} '#{@name}' has no need to update") if @item.like? desired_state
          diff = get_diff(@item, desired_state)
          Chef::Log.info "Update #{@resource_name} '#{@name}'#{diff}"
          Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
          Chef::Log.debug "Current state: #{JSON.pretty_generate(@item.data)}"
          Chef::Log.debug "Desired state: #{JSON.pretty_generate(desired_state)}"
          @context.converge_by "Updated #{@resource_name} '#{@name}'" do
            @item.update(desired_state)
          end
          save_res_info
        end
      end
    end
  end
end
