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
Dir[File.dirname(__FILE__) + '/resource_providers/*.rb'].each { |file| require file }

module OneviewCookbook
  # Helpers for Oneview Resources
  module Helper
    # All-in-one method for performing an action on a resource
    # @param context Context from the resource action block (self)
    # @param [String, Symbol] type Name of the resource type. e.g., :EthernetNetwork
    # @param [String, Symbol] action Action method to call on the resource. e.g., :create_or_update
    def self.do_resource_action(context, type, action)
      klass = OneviewCookbook::Helper.get_resource_class(context, type)
      res = klass.new(context)
      res.send(action)
    end

    # Get the resource class by name, taking into consideration the resource's properties
    # @param context Context from the resource action block (self)
    # @param [String, Symbol] type Name of the resource type. e.g., :EthernetNetwork
    # @return [Class] Resource class
    def self.get_resource_class(context, resource_type)
      load_sdk(context)
      api_version = context.property_is_set?(:api_version) ? context.api_version : context.node['oneview']['api_version']
      api_module = get_api_module(api_version)
      api_variant = context.property_is_set?(:api_variant) ? context.api_variant : context.node['oneview']['api_variant']
      api_module.resource_named(resource_type, api_variant)
    end

    # Get the API module given an api_version
    # @param [Fixnum, String] api_version
    # @return [Module] Resource module
    def self.get_api_module(api_version)
      OneviewCookbook.const_get("API#{api_version}")
    rescue NameError
      raise NameError, "The api_version #{api_version} is not supported. Please use a supported version."
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
      case client
      when OneviewSDK::Client
        return client
      when Hash
        options = Hash[client.map { |k, v| [k.to_sym, v] }] # Convert string keys to symbols
        unless options[:logger] # Use the Chef logger
          options[:logger] = Chef::Log
          options[:log_level] = Chef::Log.level
        end
        options[:log_level] ||= Chef::Log.level
        return OneviewSDK::Client.new(options)
      when NilClass
        options = {}
        options[:logger] = Chef::Log
        options[:log_level] = Chef::Log.level
        return OneviewSDK::Client.new(options) # Rely on the ENV variables being set
      else
        raise "Invalid client #{client}. Must be a hash or OneviewSDK::Client"
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
        con = convert_keys(v, conversion_method) if v && v.class == Hash
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
      recursive_diff(data, desired_data, "\n", '  ')
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

    # Keeping all the old helper methods until we update all the resources

    # Load (and install if necessary) the oneview-sdk
    def load_sdk
      gem 'oneview-sdk', node['oneview']['ruby_sdk_version']
      require 'oneview-sdk'
      Chef::Log.debug("Loaded oneview-sdk #{node['oneview']['ruby_sdk_version']} (#{OneviewSDK::VERSION})")
    rescue LoadError => e
      Chef::Log.debug("Could not load gem oneview-sdk #{node['oneview']['ruby_sdk_version']}. Message: #{e.message}")
      Chef::Log.info("Could not load gem oneview-sdk #{node['oneview']['ruby_sdk_version']}. Making sure it's installed...")
      chef_gem 'oneview-sdk' do
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

    # Builds client and resource instance
    # @return [OneviewSDK::Resource] OneView resource instance with the specified data
    def load_resource
      load_sdk
      c = build_client(client)
      if defined?(type) # For generic resource
        klass = get_resource_named(type)
      else # Determine type from resource
        klass_name = resource_name.to_s.split('_').map(&:capitalize).join
        klass_name.gsub!(/^Oneview/, '')
        klass = get_resource_named(klass_name)
      end
      new_data = JSON.parse(data.to_json) rescue data
      item = klass.new(c, new_data)
      item['name'] ||= name
      item
    end

    # Get the associated class of the given string or symbol
    # @param [String] type OneviewSDK resource name
    # @return [Class] OneviewSDK resource class
    def get_resource_named(type)
      klass = OneviewSDK.resource_named(type)
      raise "Invalid OneView Resource type '#{type}'" unless klass
      klass
    end

    # Makes it easy to build a Client object
    # @param [Hash, OneviewSDK::Client] client Appliance info hash or client object.
    # @return [OneviewSDK::Client] Client object
    def build_client(client = nil)
      case client
      when OneviewSDK::Client
        return client
      when Hash
        options = Hash[client.map { |k, v| [k.to_sym, v] }] # Convert string keys to symbols
        unless options[:logger] # Use the Chef logger
          options[:logger] = Chef::Log
          options[:log_level] = Chef::Log.level
        end
        options[:log_level] ||= Chef::Log.level
        return OneviewSDK::Client.new(options)
      when NilClass
        options = {}
        options[:logger] = Chef::Log
        options[:log_level] = Chef::Log.level
        return OneviewSDK::Client.new(options)
      else
        raise "Invalid client #{client}. Must be a hash or OneviewSDK::Client"
      end
    end

    # Save the data from a resource to a node attribute
    # @param [TrueClass, FalseClass, Array] attributes Attributes to save (or true/false)
    # @param [String, Symbol] name Resource name
    # @param [OneviewSDK::Resource] item to save data for
    def save_res_info(attributes, name, item)
      ov_url = item.client.url.to_s
      case attributes
      when Array # save subset
        node.default['oneview'][ov_url][name.to_s] = item.data.select { |k, _v| attributes.include?(k) }
      when TrueClass # save all
        node.default['oneview'][ov_url][name.to_s] = item.data
      end
    rescue StandardError => e
      Chef::Log.error "Failed to save resource data for '#{name}': #{e.message}"
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
