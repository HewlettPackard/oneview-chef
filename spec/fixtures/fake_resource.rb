# Poser class acting like Chef::Resource
class FakeResource
  attr_accessor \
    :resource_name,
    :api_version,
    :api_variant,
    :api_header_version,
    :name,
    :node,
    :client,
    :data

  def initialize(opts = {})
    @resource_name = opts[:resource_name] || 'oneview_fake_resource'
    @api_version = opts[:api_version] if opts[:api_version]
    @api_variant = opts[:api_variant] if opts[:api_variant]
    @api_header_version = opts[:api_header_version] if opts[:api_header_version]
    @name = opts[:name] || 'fake_res'
    @node = opts[:node] || { 'oneview' => { 'api_version' => 300, 'api_variant' => :C7000 } }
    @client = opts[:client] if opts[:client]
    @data = opts[:data] || {}
  end

  def property_is_set?(property)
    !instance_variable_get("@#{property}").nil?
  end
end
