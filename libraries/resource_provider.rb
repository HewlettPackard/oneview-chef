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
      :sdk_resource_type, # Keep track of the SDK resource class name
      :sdk_base_module    # Keep track of the internal base SDK module

    def initialize(context)
      @sdk_base_module = OneviewSDK
      @context = context
      @resource_name = context.resource_name
      @name = context.name
      klass = parse_namespace
      c = if @sdk_base_module == OneviewSDK::ImageStreamer
            OneviewCookbook::Helper.build_image_streamer_client(context.client)
          else
            OneviewCookbook::Helper.build_client(context.client)
          end
      new_data = JSON.parse(context.data.to_json) rescue context.data
      @item = context.property_is_set?(:api_header_version) ? klass.new(c, new_data, context.api_header_version) : klass.new(c, new_data)
      @item['name'] ||= context.name
    end

    # rubocop:disable Metrics/MethodLength
    # Helper method that analyzes the namespace and defines the class variables and the resource class itself
    # @return [OneviewSDK::Resource] SDK resource class
    # @raise [NameError] If for some reason the method could not resolve the namespace to a OneviewSDK::Resource
    def parse_namespace
      klass_name = self.class.to_s
      Chef::Log.debug("Resource '#{@resource_name}' received with the '#{klass_name}' class name")
      name_arr = klass_name.split('::')
      @sdk_resource_type = name_arr.pop.gsub(/Provider$/i, '') # e.g., EthernetNetwork
      case name_arr.size
      when 1
        Chef::Log.debug("Resource '#{klass_name}' has no variant or api version specified.")
        # This case should really only be used for testing
        # Uses the SDK's default api version and variant
        return OneviewSDK.resource_named(@sdk_resource_type)
      when 2 # No variant specified. e.g., OneviewCookbook::API200::EthernetNetworkProvider
        Chef::Log.debug("Resource '#{klass_name}' has no variant specified.")
        @sdk_api_version = name_arr.pop.gsub(/API/i, '').to_i # e.g., 200
        @sdk_variant = nil # Not needed
      when 3
        # Parses all the namespace when it is fully specified with API version, variant or base module
        case klass_name
        when /ImageStreamer/
          Chef::Log.debug("Resource '#{klass_name}' is a Image Streamer resource.")
          @sdk_api_version = name_arr.pop.gsub(/API/i, '').to_i # e.g., 300
          @sdk_base_module = OneviewSDK.const_get(name_arr.pop) # ImageStreamer
          @sdk_variant = nil # Not needed
        else # The variant is specified. e.g., OneviewCookbook::API200::C7000::EthernetNetworkProvider
          Chef::Log.debug("Resource '#{klass_name}' has variant and api version specified.")
          @sdk_variant = name_arr.pop # e.g., C7000
          @sdk_api_version = name_arr.pop.gsub(/API/i, '').to_i # e.g., 200
        end
      else # Something is wrong
        raise NameError, "Can't build a resource object from the class #{self.class}"
      end
      klass = @sdk_base_module.resource_named(@sdk_resource_type, @sdk_api_version, @sdk_variant)
      Chef::Log.debug("#{@resource_name} namespace parsed:
        > SDK Base Module: #{@sdk_base_module} <#{@sdk_base_module.class}>
        > SDK API Version: #{@sdk_api_version} <#{@sdk_api_version.class}>
        > SDK Variant: #{@sdk_variant} <#{@sdk_variant.class}>
        > SDK Resource Type: #{@sdk_resource_type} <#{@sdk_resource_type.class}>
      ")
      klass
    end
    # rubocop:enable Metrics/MethodLength

    # Creates the OneView resource or updates it if exists
    # @param [Symbol] method_1 Method used to create/add
    # @param [Symbol] method_2 Method used to update/edit
    # @return [TrueClass, FalseClass] Returns true if the resource was created, false if updated or unchanged
    def create_or_update(method_1 = :create, method_2 = :update)
      ret_val = false
      desired_state = Marshal.load(Marshal.dump(@item.data))
      if @item.exists?
        @item.retrieve!
        if @item.like? desired_state
          Chef::Log.info("#{@resource_name} '#{@name}' is up to date")
        else
          diff = get_diff(@item, desired_state)
          diff.insert(0, '. Diff:') unless diff.to_s.empty?
          Chef::Log.info "#{method_2.to_s.capitalize} #{@resource_name} '#{@name}'#{diff}"
          Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
          Chef::Log.debug "Current state: #{JSON.pretty_generate(@item.data)}"
          Chef::Log.debug "Desired state: #{JSON.pretty_generate(desired_state)}"
          @context.converge_by "#{method_2.to_s.capitalize} #{@resource_name} '#{@name}'" do
            @item.update(desired_state)
          end
        end
      else
        create(method_1)
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
        create(method)
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
      raise "ResourceNotFound: Patch failed to apply since #{@resource_name} '#{@name}' does not exist" unless @item.retrieve!
      @context.converge_by "Performing '#{@context.operation}' at #{@context.path} with #{@context.value} in #{@resource_name} '#{@name}'" do
        @item.patch(@context.operation, @context.path, @context.value)
      end
      true
    end

    # This method is shared between multiple actions and takes care of the creation of the resource.
    # Only call this method if the resource does not exist and needs to be created.
    # @param [Symbol] method Create method
    def create(method = :create)
      Chef::Log.info "#{method.to_s.capitalize} #{@resource_name} '#{@name}'"
      @context.converge_by "#{method.to_s.capitalize} #{@resource_name} '#{@name}'" do
        @item.send(method)
      end
    end

    # Gathers the OneviewSDK correct resource class
    # @param [Symbol, String] resource Resource name/type desired
    # @param [Integer] version Version of the SDK desired
    # @param [String] variant Variant of the SDK desired
    # @return [OneviewSDK::Resource] Returns the class of the resource in the loaded API version and variant
    def resource_named(resource, version = @sdk_api_version, variant = @sdk_variant)
      @sdk_base_module.resource_named(resource, version, variant)
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

    # Generic method to retrieve and return a resource from different resources using the type and name of the resource
    # Note: The resource class base API module is the one used by the current provider
    # @param [String, Symbol] resource_class_type Type of resource to be retrieved. e.g., :GoldenImage, :FCNetwork
    # @param [Hash, String, NilClass] resource_id data containing unique IDs for this resource. e.g. uri: 'rest/fake/123456ABCDEF'
    #   If a String is passed, it assumes the attribute is the `name` for this resource. e.g. 'Resource1' is interpreted as `name: 'Resource1'`.
    #   If nothing or nil is passed, the method returns nil since there is nothing to be retrieved.
    # @param [NilClass, String, Symbol] ret_attribute Attribute of resource to be returned by this method. Use nil to return the complete resource
    # @return [OneviewSDK::Resource] if the `ret_attribute` is nil
    # @return [String, Array, Hash] that is the value of the attribute defined by the `ret_attribute` for the requested resource
    # @raise [RuntimeError] ResourceNotFound if the resource cannot be found
    # @raise [OneviewSDK::IncompleteResource] If you don't specify any unique identifiers in resource_id
    def load_resource(resource_class_type, resource_id, ret_attribute = nil)
      return unless resource_id
      data = resource_id.is_a?(Hash) ? resource_id : { name: resource_id }
      r = resource_named(resource_class_type).new(@item.client, data)
      raise "ResourceNotFound: #{resource_class_type} with data '#{data}' was not found in the appliance." unless r.retrieve!
      return r unless ret_attribute
      r[ret_attribute]
    end
  end
end

# Load all resource providers:
Dir[File.dirname(__FILE__) + '/resource_providers/*.rb'].each { |file| require file }
