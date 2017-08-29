require 'chef/log'
require 'chef/node'

# Poser class acting like Chef::Resource
class FakeResource
  attr_accessor \
    :resource_name,
    :new_resource,
    :api_version,
    :api_variant,
    :api_header_version,
    :name,
    :node,
    :client,
    :data,
    :save_resource_info

  def initialize(opts = {})
    @resource_name = opts[:resource_name] || 'oneview_fake_resource'
    @api_version = opts[:api_version] if opts[:api_version]
    @api_variant = opts[:api_variant] if opts[:api_variant]
    @api_header_version = opts[:api_header_version] if opts[:api_header_version]
    @name = opts[:name] || 'fake_res'
    @node = opts[:node] || Chef::Node.new
    @node.default['oneview'] = { 'api_version' => 200, 'api_variant' => :C7000 } unless opts[:node]
    @client = opts[:client] if opts[:client]
    @data = opts[:data] || {}
    @save_resource_info = opts[:save_resource_info] || ['uri']
    @new_resource = self
  end

  def property_is_set?(property)
    !instance_variable_get("@#{property}").nil?
  end

  def converge_by(msg = nil)
    yield
    Chef::Log.info(msg) if msg
  end
end
