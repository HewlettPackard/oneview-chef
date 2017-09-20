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

require 'logger'

module OneviewCookbook
  # Helpers for Oneview Resources
  module Helper
    # Get resource class that matches the type given
    # @param [String] type Name of the desired class type
    # @param [Module] api_module Module who the desired class type belongs to
    # @param [String] variant Variant (C7000 or Synergy)
    # @raise [RuntimeError] if resource class not found
    # @return [Class] Resource class
    def self.get_provider_named(type, api_module, variant = nil)
      api_version = api_module.to_s.split('::').last
      if variant
        raise "#{api_version} variant #{variant} is not supported!" unless api_module::SUPPORTED_VARIANTS.include?(variant.to_s)
        api_module = api_module.const_get(variant.to_s)
      end
      new_type = type.to_s.downcase.gsub(/[ -_]/, '') + 'provider'
      api_module.constants.each do |c|
        klass = api_module.const_get(c)
        next unless klass.is_a?(Class) && klass < OneviewCookbook::ResourceProvider
        name = klass.name.split('::').last.downcase.delete('_').delete('-')
        return klass if new_type =~ /^#{name}$/
      end
      raise "The '#{type}' resource does not exist for OneView #{api_version}, variant #{variant}."
    end

    # All-in-one method for performing an action on a resource
    # @param context Context from the resource action block (self)
    # @param [String, Symbol] type Name of the resource type. e.g., :EthernetNetwork
    # @param [String, Symbol] action Action method to call on the resource. e.g., :create_or_update
    # @param [Module] base_module The base API module supported. e.g. OneviewCookbook::ImageStreamer
    def self.do_resource_action(context, type, action, base_module = OneviewCookbook)
      klass = OneviewCookbook::Helper.get_resource_class(context, type, base_module)
      res = klass.new(context)
      res.send(action)
    end

    # Get the resource class by name, taking into consideration the resource's properties
    # @param context Context from the resource action block (self)
    # @param [String, Symbol] type Name of the resource type. e.g., :EthernetNetwork
    # @param [Module] base_module The base API module supported. e.g. OneviewCookbook::ImageStreamer
    # @return [Class] Resource class
    def self.get_resource_class(context, resource_type, base_module = OneviewCookbook)
      load_sdk(context)
      # Loads the api version if the property was specified directly
      context_api_version = context.new_resource.api_version if context.property_is_set?(:api_version)
      # Loads the api version if it was specified in the client
      client_api_version = if context.property_is_set?(:client)
                             if context.new_resource.client.is_a?(Hash)
                               convert_keys(context.new_resource.client, :to_sym)[:api_version]
                             elsif context.new_resource.client.is_a?(OneviewSDK::Client) # It works for both Image Streamer and OneView
                               context.new_resource.client.api_version
                             end
                           end
      # Loads the api version giving preference: property > client > node default
      api_version = context_api_version || client_api_version || context.node['oneview']['api_version']
      api_module = get_api_module(api_version, base_module)
      api_variant = context.property_is_set?(:api_variant) ? context.new_resource.api_variant : context.node['oneview']['api_variant']
      api_module.provider_named(resource_type, api_variant)
    end

    # Get the API module given an api_version
    # @param [Integer, String] api_version
    # @param [Module] base_module The base API module supported. e.g. OneviewCookbook::ImageStreamer
    # @return [Module] Resource module
    def self.get_api_module(api_version, base_module = OneviewCookbook)
      base_module.const_get("API#{api_version}")
    rescue NameError
      raise NameError, "The api_version #{api_version} is not supported in #{base_module}. Please use a supported version."
    end

    # Load (and install if necessary) the oneview-sdk
    # @param context Context from the resource action block (self)
    def self.load_sdk(context)
      node = context.node
      gem 'oneview-sdk', node['oneview']['ruby_sdk_version']
      require 'oneview-sdk'
      Chef::Log.debug("Loaded oneview-sdk #{node['oneview']['ruby_sdk_version']} (#{OneviewSDK::VERSION})")
    rescue LoadError => e
      Chef::Log.debug("Could not load gem oneview-sdk #{node['oneview']['ruby_sdk_version']}. Message: #{e.message}")
      Chef::Log.info("Could not load gem oneview-sdk #{node['oneview']['ruby_sdk_version']}. Making sure it's installed...")
      context.chef_gem 'oneview-sdk' do
        version node['oneview']['ruby_sdk_version']
        compile_time true if Chef::Resource::ChefGem.method_defined?(:compile_time)
      end
      begin # Try to load the specified version of the oneview-sdk gem again
        gem 'oneview-sdk', node['oneview']['ruby_sdk_version']
        require 'oneview-sdk'
        Chef::Log.debug("Loaded oneview-sdk version #{OneviewSDK::VERSION}")
      rescue LoadError => er
        Chef::Log.error("Version #{node['oneview']['ruby_sdk_version']} of oneview-sdk cannot be loaded. Message: #{er.message}")
        require 'oneview-sdk'
        Chef::Log.error("Loaded version #{OneviewSDK::VERSION} of the oneview-sdk gem instead")
      end
    end

    # Makes it easy to build a Client object
    # @param [Hash, OneviewSDK::Client] client Appliance info hash or client object.
    # @return [OneviewSDK::Client] Client object
    def self.build_client(client = nil)
      Chef::Log.debug("Building OneView client with:\n#{client}\n\n")
      case client
      when OneviewSDK::Client
        client
      when Hash
        options = Hash[client.map { |k, v| [k.to_sym, v] }] # Convert string keys to symbols
        unless options[:logger] # Use the Chef logger
          options[:logger] = Chef::Log
          options[:log_level] = Chef::Log.level
        end
        options[:log_level] ||= Chef::Log.level
        OneviewSDK::Client.new(options)
      when NilClass
        options = {}
        options[:logger] = Chef::Log
        options[:log_level] = Chef::Log.level
        OneviewSDK::Client.new(options) # Rely on the ENV variables being set
      else
        raise "Invalid client #{client}. Must be a hash or OneviewSDK::Client"
      end
    end

    # Makes it easy to build a Image Streamer Client object
    # @param [Hash, OneviewSDK::ImageStreamer::Client] client Appliance info hash or client object.
    # @return [OneviewSDK::ImageStreamer::Client] Client object
    def self.build_image_streamer_client(client = nil)
      Chef::Log.debug("Building Image Streamer client with:\n#{client}\n\n")
      case client
      when OneviewSDK::ImageStreamer::Client
        client
      when Hash
        options = Hash[client.map { |k, v| [k.to_sym, v] }] # Convert string keys to symbols
        unless options[:logger] # Use the Chef logger
          options[:logger] = Chef::Log
          options[:log_level] = Chef::Log.level
        end
        options[:log_level] ||= Chef::Log.level
        return OneviewSDK::ImageStreamer::Client.new(options) unless options[:oneview_client] # Rely on token being set
        ov_client = build_client(options.delete(:oneview_client))
        OneviewSDK::ImageStreamer::Client.new(options.merge(token: ov_client.token))
      when NilClass
        options = {}
        options[:logger] = Chef::Log
        options[:log_level] = Chef::Log.level
        OneviewSDK::ImageStreamer::Client.new(options) # Rely on the ENV variables being set
      else
        raise "Invalid client #{client}. Must be a hash or OneviewSDK::ImageStreamer::Client"
      end
    end

    # Utility method that converts Hash symbol to string keys
    # @param [Hash] info Hash containing the dataset
    # @param [Symbol] conversion_method Symbol representing the method to be called in the conversion
    # @return [Hash] Hash with the keys converted. Returns nil if info is invalid.
    def self.convert_keys(info, conversion_method)
      return nil unless info
      support = {}
      info.each do |k, v|
        if v.class == Hash
          con = convert_keys(v, conversion_method)
        elsif v.class == Array
          con = v.map { |h| convert_keys(h, conversion_method) } if v.any? { |value| value.class == Hash }
        end
        support[k.public_send(conversion_method)] = con || v
      end
      support
    end

    # Get the diff of the current resource state and the desired state
    # @param [OneviewSDK::Resource] resource Resource containing current state
    # @param [Hash] desired_data Desired state for the resource
    # @return [String] Diff string (multi-line). Returns empty string if there is no diff or an error occurred
    def self.get_diff(resource, desired_data)
      data = resource.is_a?(Hash) ? resource : resource.data
      recursive_diff(data, desired_data, '', '  ')
    rescue StandardError => e
      Chef::Log.error "Failed to generate resource diff for '#{resource['name']}': #{e.message}"
      '' # Return empty diff
    end

    # Get the diff of the current resource state and the desired state
    # @param [Hash] data Current state of the resource
    # @param [Hash] desired_data Desired state for the resource
    # @param [String] str Current diff string to append to (used for recursive calls)
    # @param [String] indent String used to indent the output
    # @raise [StandardError] if the comparison cannot be made due to an unexpected error
    # @return [String] Diff string (multi-line). Returns empty string if there is no diff
    def self.recursive_diff(data, desired_data, str = '', indent = '')
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

    # Retrieve a resource by type and identifier (name or data)
    # @param [Hash, OneviewSDK::Client] client Appliance info hash or client object.
    # @param type [String, Symbol] Type of resource to be retrieved. e.g., :GoldenImage, :FCNetwork
    # @param id [String, Symbol, Hash] Name of the resource or Hash of data to retrieve by.
    #   Examples: 'EthNet1', { uri: '/rest/fake/123ABC' }
    # @param ret_attribute [NilClass, String, Symbol] If specified, returns a specific attribute of the resource.
    #   When nil, the complete resource will be returned.
    # @param api_ver [Integer] API version used to build the full type namespace.
    #   Defaults to 200 (unless node attribute is passed)
    # @param variant [String, Symbol] API variant used to build the full type namespace.
    #   Defaults to 'C7000' (unless node attribute is passed)
    # @param node [Chef::Node] Node object used to provide the api_ver and variant. If provided, they will default
    #   to node['oneview']['api_version'] and node['oneview']['api_variant']
    # @return [OneviewSDK::Resource] if the `ret_attribute` is nil
    # @return [String, Array, Hash] that is, the value of the resource attribute defined by `ret_attribute`
    # @raise [OneviewSDK::NotFound] ResourceNotFound if the resource cannot be found
    # @raise [OneviewSDK::IncompleteResource] If you don't specify any unique identifiers in `id`
    def self.load_resource(client, type: nil, id: nil, ret_attribute: nil, api_ver: nil, variant: nil, node: nil, base_module: OneviewSDK)
      raise(ArgumentError, 'Must specify a resource type') unless type
      return unless id
      c = build_client(client)
      api_ver ||= node['oneview']['api_version'] rescue 200
      variant ||= node['oneview']['api_variant'] rescue 'C7000'
      klass = base_module.resource_named(type, api_ver, variant)
      data = id.is_a?(Hash) ? id : { name: id }
      r = klass.new(c, data)
      raise(OneviewSDK::NotFound, "#{type} with data '#{data}' was not found") unless r.retrieve!
      return r unless ret_attribute
      r[ret_attribute]
    end
  end
end

require_relative 'resource_provider'
