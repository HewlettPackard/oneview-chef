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
    SDK_MODULE   = nil # Needs to be overridden in the provider's class
    SDK_VARIANT  = nil # Needs to be overridden in the provider's class
    SDK_RESOURCE = nil # Needs to be overridden in the provider's class

    attr_accessor \
      :context,       # Ususally a Chef resource's context
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
      klass = OneviewSDK.resource_named(@sdk_resource_type, @sdk_api_version, @sdk_variant)
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
        Chef::Log.info("'#{@resource_name} #{@name}' exists. Skipping")
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

    private

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
    # @param [Hash] info Hash containing the dataset
    # @param [Symbol] conversion_method Symbol representing the method to be called in the conversion
    # @return [Hash] Hash with the keys converted. Returns nil if info is invalid.
    def convert_keys(info, conversion_method)
      return nil unless info
      support = {}
      info.each do |k, v|
        con = convert_keys(v, conversion_method) if v && v.class == Hash
        support[k.public_send(conversion_method)] = con || v
      end
      support
    end

    # Get the diff of the current resource state and the desired state
    # @param [OneviewSDK::Resource] resource Resource containing current state
    # @param [Hash] desired_data Desired state for the resource
    # @return [String] Diff string (multi-line). Returns empty string if there is no diff or an error occurred
    def get_diff(resource, desired_data)
      data = resource.is_a?(Hash) ? resource : resource.data
      recursive_diff(data, desired_data, "\n", '  ')
    rescue StandardError => e
      Chef::Log.error "Failed to generate resource diff for #{@resource_name} '#{@name}': #{e.message}"
      '' # Return empty diff
    end

    # Get the diff of the current resource state and the desired state
    # @param [Hash] data Current state of the resource
    # @param [Hash] desired_data Desired state for the resource
    # @param [String] str Current diff string to append to (used for recursive calls)
    # @param [String] indent String used to indent the output
    # @raise [StandardError] if the comparison cannot be made due to an unexpected error
    # @return [String] Diff string (multi-line). Returns empty string if there is no diff
    def recursive_diff(data, desired_data, str = '', indent = '')
      unless desired_data.class == Hash
        return '' if data == desired_data
        return str << "\n#{indent}#{data.nil? ? 'nil' : data} -> #{desired_data}"
      end
      return str << "\n#{indent}nil -> #{desired_data}" if data.nil?
      return str << "\n#{indent}#{data} -> #{desired_data}" unless data && data.class == Hash
      desired_data.each do |key, val|
        if val.is_a?(Hash)
          if data[key].class == Hash
            str2 = recursive_diff(data[key], val, '', "#{indent}  ")
            str << "\n#{indent}#{key}:#{str2}" unless str2.empty?
          else
            str << "\n#{indent}#{key}: #{data[key].nil? ? 'nil' : data[key]} -> #{val}"
          end
        elsif val != data[key]
          str << "\n#{indent}#{key}: #{data[key].nil? ? 'nil' : data[key]} -> #{val}"
        end
      end
      str
    end
  end
end
