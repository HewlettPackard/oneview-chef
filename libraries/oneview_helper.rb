module Opscode
  # Helpers for Oneview Resources
  module OneviewHelper
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
      klass_name = resource_name.to_s.split('_').map(&:capitalize).join
      klass = get_resource_named(klass_name)
      item = klass.new(c, new_resource.data)
      item['name'] ||= new_resource.name
      item
    end

    # Get the associated class of the given string or symbol
    # @param [String] type OneViewSDK resource name
    # @return [Class] OneViewSDK resource class
    def get_resource_named(type)
      klass = OneviewSDK.resource_named(type)
      fail "Invalid OneView Resource type '#{type}'" unless klass
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
        log_level = client['log_level'] || client[:log_level] || Chef::Log.level
        return OneviewSDK::Client.new(client.merge(log_level: log_level))
      else
        fail "Invalid client #{client}. Must be a hash or OneviewSDK::Client"
      end
    end

    # Save the data from a resource to a node attribute
    # @param [TrueClass, FalseClass, Array] attributes Attributes to save (or true/false)
    # @param [String, Symbol] name Resource name
    # @param [Hash] data Data hash to save
    def save_res_info(attributes, name, data)
      case attributes
      when Array
        node.default['oneview']['resources'][name] = data.select { |k, _v| attributes.include?(k) }
      when TrueClass # save all
        node.default['oneview']['resources'][name] = data
      end
    rescue StandardError => e
      Chef::Log.error "Failed to save resource data for '#{name}': #{e.message}"
    end
  end
end
