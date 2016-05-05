# Helpers for Oneview Resources
module OneviewHelper
  # Load (and install if necessary) the oneview-sdk
  def load_sdk(context)
    gem 'oneview-sdk', node['oneview']['ruby_sdk_version']
    require 'oneview-sdk'
    Chef::Log.debug("Found gem oneview-sdk (version #{node['oneview']['ruby_sdk_version']})")
  rescue LoadError
    Chef::Log.info("Did not find gem oneview-sdk (version #{node['oneview']['ruby_sdk_version']}). Installing now")
    context.chef_gem 'oneview-sdk' do
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
  # @param [Hash, OneviewSDK::Client] ilo Machine info or client object.
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
end
