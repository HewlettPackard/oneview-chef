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
    # Load (and install if necessary) the oneview-sdk
    def load_sdk
      gem 'oneview-sdk', node['oneview']['ruby_sdk_version']
      require 'oneview-sdk'
      Chef::Log.debug("Found gem oneview-sdk (version #{node['oneview']['ruby_sdk_version']})")
    rescue LoadError
      Chef::Log.info("Did not find gem oneview-sdk (version #{node['oneview']['ruby_sdk_version']}). Installing now")
      chef_gem 'oneview-sdk' do
        version node['oneview']['ruby_sdk_version']
        compile_time true if Chef::Resource::ChefGem.method_defined?(:compile_time)
      end
      require 'oneview-sdk'
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
      item = klass.new(c, data)
      item['name'] ||= name
      item
    end

    # Get the associated class of the given string or symbol
    # @param [String] type OneViewSDK resource name
    # @return [Class] OneViewSDK resource class
    def get_resource_named(type)
      klass = OneviewSDK.resource_named(type)
      raise "Invalid OneView Resource type '#{type}'" unless klass
      klass
    end

    # Makes it easy to build a Client object
    # @param [Hash, OneviewSDK::Client] client Machine info or client object.
    # @return [OneviewSDK::Client] Client object
    def build_client(client)
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
    def convert_keys(info, conversion_method)
      support = {}
      info.each do |k, v|
        convert_keys(v, conversion_method) if v && v.class == Hash
        support[k.public_send(conversion_method)] = v
      end
      support
    end
  end
end
