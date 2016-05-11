property :client, required: true
property :name, [String, Symbol], required: true
property :options, Hash, default: {}
property :type, [String, Symbol], required: true

action_class do
  include Opscode::OneviewHelper
end

action :create do
  load_sdk
  klass = get_resource_named(type)
  c = build_client(client)
  item = klass.new(c, { name: name }.merge(options))
  if item.exists?
    item.retrieve!
    if item.like? options
      Chef::Log.info("#{type} '#{name}' is up to date")
    else
      Chef::Log.info "Update #{type} '#{name}'"
      converge_by "Update #{type} '#{name}'" do
        item.update(options)
      end
    end
  else
    Chef::Log.info "Create #{type} '#{name}'"
    converge_by "Create #{type} '#{name}'" do
      item.create
    end
  end
end

action :create_only do
  load_sdk
  klass = get_resource_named(type)
  c = build_client(client)
  item = klass.new(c, { name: name }.merge(options))
  if item.exists?
    Chef::Log.info("#{type} '#{name}' exists. Skipping")
  else
    Chef::Log.info "Create #{type} '#{name}'"
    converge_by "Create #{type} '#{name}'" do
      item.create
    end
  end
end

action :delete do
  load_sdk
  klass = get_resource_named(type)
  c = build_client(client)
  item = klass.new(c, { name: name }.merge(options))
  if item.retrieve!
    converge_by "Delete #{type} '#{name}'" do
      item.delete
    end
  end
end
