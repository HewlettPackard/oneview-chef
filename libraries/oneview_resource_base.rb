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

module OneviewCookbook
  # Define default properties for all resources
  module ResourceBaseProperties
    # Loads the default properties for all resources
    def self.load(context)
      context.property :client, required: true
      context.property :name, [String, Symbol], required: true
      context.property :data, Hash, default: {}
      context.property :save_resource_info, [TrueClass, FalseClass, Array], default: context.node['oneview']['save_resource_info']
      context.property :api_version, Fixnum # This version will be used in a header for API requests
      context.property :api_module, Fixnum, default: context.node['oneview']['api_module']
      context.property :api_variant, [String, Symbol], default: context.node['oneview']['api_variant']
    end
  end

  # Oneview Resources base actions
  module ResourceBase
    # Creates an OneView resource or updates it if exists
    # @param [OneviewSDK::Resource] item item to be created or updated
    # @param [Symbol] method_1 Create or add method
    # @param [Symbol] method_2 Update or edit method
    # @return [TrueClass, FalseClass] Returns true if the resource was created, false if updated or unchanged
    def create_or_update(item = nil, method_1 = :create, method_2 = :update)
      ret_val = false
      item ||= load_resource
      temp = Marshal.load(Marshal.dump(item.data))
      if item.exists?
        item.retrieve!
        if item.like? temp
          Chef::Log.info("#{resource_name} '#{name}' is up to date")
        else
          Chef::Log.info "#{method_2.to_s.capitalize} #{resource_name} '#{name}'"
          Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
          Chef::Log.debug "Current state: #{JSON.pretty_generate(item.data)}"
          Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
          diff = get_diff(item, temp)
          converge_by "#{method_2.to_s.capitalize} #{resource_name} '#{name}'#{diff}" do
            item.update(temp)
          end
        end
      else
        Chef::Log.info "#{method_1.to_s.capitalize} #{resource_name} '#{name}'"
        converge_by "#{method_1.to_s.capitalize} #{resource_name} '#{name}'" do
          item.send(method_1)
        end
        ret_val = true
      end
      save_res_info(save_resource_info, name, item)
      ret_val
    end

    # Adds a resource to OneView or edits it if exists
    # @param [OneviewSDK::Resource] item item to be added or edited
    # @return [TrueClass, FalseClass] Returns true if the resource was added, false if edited or unchanged
    def add_or_edit(item = nil)
      create_or_update(item, :add, :edit)
    end

    # Creates a OneView resource only if it doesn't exist
    # @param [OneviewSDK::Resource] item item to be created
    # @param [Symbol] method Create or add method
    # @return [TrueClass, FalseClass] Returns true if the resource was created/added
    def create_if_missing(item = nil, method = :create)
      ret_val = false
      item ||= load_resource
      if item.exists?
        Chef::Log.info("'#{resource_name} #{name}' exists. Skipping")
        item.retrieve! if save_resource_info
      else
        Chef::Log.info "#{method.to_s.capitalize} #{resource_name} '#{name}'"
        converge_by "#{method.to_s.capitalize} #{resource_name} '#{name}'" do
          item.send(method)
        end
        ret_val = true
      end
      save_res_info(save_resource_info, name, item)
      ret_val
    end

    # Adds a resource to OneView only if it doesn't exist
    # @param [OneviewSDK::Resource] item item to be added
    # @return [TrueClass, FalseClass] Returns true if the resource was added
    def add_if_missing(item = nil)
      create_if_missing(item, :add)
    end

    # Delete a OneView resource if it exists
    # @param [OneviewSDK::Resource] item Item to be deleted
    # @param [Symbol] method Delete or remove method
    # @return [TrueClass, FalseClass] Returns true if the resource was deleted/removed
    def delete(item = nil, method = :delete)
      item ||= load_resource
      return false unless item.retrieve!
      converge_by "#{method.to_s.capitalize} #{resource_name} '#{name}'" do
        item.send(method)
      end
      true
    end

    # Removes a resource from OneView if it exists
    # @param [OneviewSDK::Resource] item item to be removed
    # @return [TrueClass, FalseClass] Returns true if the resource was removed
    def remove(item = nil)
      delete(item, :remove)
    end

    # Let Chef know that the why-run flag is supported
    def whyrun_supported?
      true
    end
  end
end
