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

    # Get the associated class of the given string or symbol
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
        log_level = client['log_level'] || client[:log_level] || Chef::Log.level
        return OneviewSDK::Client.new(client.merge(log_level: log_level))
      else
        raise "Invalid client #{client}. Must be a hash or OneviewSDK::Client"
      end
    end

    # Create a OneView resource or update it if exists
    # @param [OneviewSDK::Resource] item OneView SDK resource to be created
    # @return [TrueClass, FalseClass] Returns true if the resource was created, false if updated
    def create_or_update(item)
      temp = item.data.clone
      if item.exists?
        item.retrieve!
        if item.like? temp
          Chef::Log.info("#{resource_name} '#{name}' is up to date")
        else
          Chef::Log.info "#{resource_name} '#{name}' Chef resource differs from OneView resource."
          Chef::Log.info "Update #{resource_name} '#{name}'"
          item.update(temp)
          false
        end
      else
        Chef::Log.info "Create #{resource_name} '#{name}'"
        item.create
        true
      end
    end

    # Create a OneView resource only if doesn't exists
    # @param [OneviewSDK::Resource] item OneView SDK resource to be created
    # @return [TrueClass, FalseClass] Returns true if the resource was created
    def create_only(item)
      if item.exists?
        Chef::Log.info("'#{resource_name} #{name}' exists. Skipping")
        item.retrieve!
        false
      else
        Chef::Log.info "Create #{resource_name} '#{name}'"
        item.create
        true
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
