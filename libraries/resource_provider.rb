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
  # Base class for resource providers
  class ResourceProvider
    attr_accessor \
      :context,       # Ususally a Chef resource's context (self)
      :resource_name, # The Chef resource's type. e.g., oneview_ethernet_network
      :name,          # Name of the Chef resource. e.g., EthNet1
      :item,          # The OneviewSDK resource instance
      :sdk_api_version,  # Keep track of the API version used for the SDK resource class
      :sdk_variant,      # Keep track of the variant used for the SDK resource class
      :sdk_resource_type # Keep track of the SDK resource class name

    def initialize(context)
      @context = context
      @resource_name = context.resource_name
      @name = context.name
      name_arr = self.class.to_s.split('::')
      case name_arr.size
      when 2 # No variant or api version specified. (OneviewCookbook::ResourceProvider)
        # This case should really only be used for testing
        # Uses the SDK's default api version and variant
        @sdk_resource_type = name_arr.pop.gsub(/Provider$/i, '') # e.g., EthernetNetwork
        klass = OneviewSDK.resource_named(@sdk_resource_type)
      when 3 # No variant specified. e.g., OneviewCookbook::API200::EthernetNetworkProvider
        @sdk_resource_type = name_arr.pop.gsub(/Provider$/i, '') # e.g., EthernetNetwork
        @sdk_api_version = name_arr.pop.gsub(/API/i, '').to_i # e.g., 200
        @sdk_variant = nil # Not needed
      when 4 # The variant is specified. e.g., OneviewCookbook::API200::C7000::EthernetNetworkProvider
        @sdk_resource_type = name_arr.pop.gsub(/Provider$/i, '') # e.g., EthernetNetwork
        @sdk_variant = name_arr.pop # e.g., C7000
        @sdk_api_version = name_arr.pop.gsub(/API/i, '').to_i # e.g., 200
      else # Something is wrong
        raise "Can't build a resource object from the class #{self.class}"
      end
      klass ||= OneviewSDK.resource_named(@sdk_resource_type, @sdk_api_version, @sdk_variant)
      c = OneviewCookbook::Helper.build_client(context.client)
      new_data = JSON.parse(context.data.to_json) rescue context.data
      @item = context.property_is_set?(:api_header_version) ? klass.new(c, new_data, context.api_header_version) : klass.new(c, new_data)
      @item['name'] ||= context.name
    end

    # Creates the OneView resource or updates it if exists
    # @param [Symbol] method_1 Create or add method
    # @param [Symbol] method_2 Update or edit method
    # @return [TrueClass, FalseClass] Returns true if the resource was created, false if updated or unchanged
    def create_or_update(method_1 = :create, method_2 = :update)
      ret_val = false
      temp = Marshal.load(Marshal.dump(@item.data))
      if @item.exists?
        @item.retrieve!
        if @item.like? temp
          Chef::Log.info("#{@resource_name} '#{@name}' is up to date")
        else
          Chef::Log.info "#{method_2.to_s.capitalize} #{@resource_name} '#{@name}'"
          Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
          Chef::Log.debug "Current state: #{JSON.pretty_generate(@item.data)}"
          Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
          diff = get_diff(@item, temp)
          @context.converge_by "#{method_2.to_s.capitalize} #{@resource_name} '#{@name}'#{diff}" do
            @item.update(temp)
          end
        end
      else
        Chef::Log.info "#{method_1.to_s.capitalize} #{@resource_name} '#{@name}'"
        @context.converge_by "#{method_1.to_s.capitalize} #{@resource_name} '#{@name}'" do
          @item.send(method_1)
        end
        ret_val = true
      end
      save_res_info
      ret_val
    end

    # Adds the resource to OneView or edits it if exists
    # @return [TrueClass, FalseClass] Returns true if the resource was added, false if edited or unchanged
    def add_or_edit
      create_or_update(:add, :edit)
    end

    # Creates the OneView resource only if it doesn't exist
    # @param [Symbol] method Create or add method
    # @return [TrueClass, FalseClass] Returns true if the resource was created/added
    def create_if_missing(method = :create)
      ret_val = false
      if @item.exists?
        Chef::Log.info("#{@resource_name} '#{@name}' exists. Skipping")
        @item.retrieve! if @context.save_resource_info
      else
        Chef::Log.info "#{method.to_s.capitalize} #{@resource_name} '#{@name}'"
        @context.converge_by "#{method.to_s.capitalize} #{@resource_name} '#{@name}'" do
          @item.send(method)
        end
        ret_val = true
      end
      save_res_info
      ret_val
    end

    # Adds a resource to OneView only if it doesn't exist
    # @return [TrueClass, FalseClass] Returns true if the resource was added
    def add_if_missing
      create_if_missing(:add)
    end

    # Delete the OneView resource if it exists
    # @param [Symbol] method Delete or remove method
    # @return [TrueClass, FalseClass] Returns true if the resource was deleted/removed
    def delete(method = :delete)
      return false unless @item.retrieve!
      @context.converge_by "#{method.to_s.capitalize} #{@resource_name} '#{@name}'" do
        @item.send(method)
      end
      true
    end

    # Remove the OneView resource if it exists
    # @return [TrueClass, FalseClass] Returns true if the resource was removed
    def remove
      delete(:remove)
    end

    # Performs patch operation
    # It needs the context properties 'operation' and 'path'.
    # 'value' property is optional.
    # @return [TrueClass] true if the resource was patched
    def patch
      invalid_params = @context.operation.nil? || @context.path.nil?
      raise "InvalidParameters: Parameters 'operation' and 'path' must be set for patch" if invalid_params
      @item.retrieve!
      @context.converge_by "Performing '#{@context.operation}' at #{@context.path} with #{@context.value} in #{@resource_name} '#{@name}'" do
        @item.patch(@context.operation, @context.path, @context.value)
      end
      true
    end

    # Gathers the OneviewSDK correct resource class
    # @param [Symbol | String] resource Resource name/type desired
    # @param [Integer] version Version of the SDK desired
    # @param [String] variant Variant of the SDK desired
    # @return [OneviewSDK::Resource] Returns the class of the resource in the loaded API version and variant
    def resource_named(resource, version = @sdk_api_version, variant = @sdk_variant)
      OneviewSDK.resource_named(resource, version, variant)
    end

    # Save the data from a resource to a node attribute
    # @param [TrueClass, FalseClass, Array] attributes Attributes to save (or true/false)
    # @param [String, Symbol] name Resource name
    # @param [OneviewSDK::Resource] item to save data for
    # (@context.save_resource_info, @name, @item)
    def save_res_info
      ov_url = @item.client.url.to_s
      case @context.save_resource_info
      when Array # save subset
        @context.node.default['oneview'][ov_url][@name.to_s] = @item.data.select { |k, _v| @context.save_resource_info.include?(k) }
      when TrueClass # save all
        @context.node.default['oneview'][ov_url][@name.to_s] = @item.data
      end
    rescue StandardError => e
      Chef::Log.error "Failed to save resource data for '#{@name}': #{e.message}"
    end

    # Utility method that converts Hash symbol to string keys
    # See the OneviewCookbook::Helper.convert_keys method for param details
    def convert_keys(info, conversion_method)
      OneviewCookbook::Helper.convert_keys(info, conversion_method)
    end

    # Get the diff of the current resource state and the desired state
    # See the OneviewCookbook::Helper.get_diff method for param details
    def get_diff(resource, desired_data)
      OneviewCookbook::Helper.get_diff(resource, desired_data)
    end

    # Get the diff of the current resource state and the desired state
    # See the OneviewCookbook::Helper.recursive_diff method for param details
    def recursive_diff(data, desired_data, str = '', indent = '')
      OneviewCookbook::Helper.recursive_diff(data, desired_data, str, indent)
    end
  end
end

# Load all resource providers:
Dir[File.dirname(__FILE__) + '/resource_providers/*.rb'].each { |file| require file }
