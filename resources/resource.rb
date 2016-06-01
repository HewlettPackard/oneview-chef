property :client, required: true
property :name, [String, Symbol], required: true
property :data, Hash, default: {}
property :type, [String, Symbol], required: true
property :save_resource_info, [TrueClass, FalseClass, Array], default: node['oneview']['save_resource_info']

default_action :create

action_class do
  include Opscode::OneviewHelper
  def whyrun_supported?
    true
  end
end

action :create do
  load_sdk
  klass = get_resource_named(type)
  c = build_client(client)
  item = klass.new(c, { name: name }.merge(data))
  if item.exists?
    item.retrieve!
    if item.like? data
      Chef::Log.info("#{type} '#{name}' is up to date")
    else
      Chef::Log.debug "#{type} '#{name}' Chef resource differs from OneView resource."
      Chef::Log.debug "Chef Resource details: #{{ name: name }.merge(data)}"
      Chef::Log.debug "OneView Resource details: #{item.data}" # Note: This data is merged with the Chef data; not just from OV.
      Chef::Log.info "Update #{type} '#{name}'"
      converge_by "Update #{type} '#{name}'" do
        item.update(data) # Note: Assumes resources supports #update
      end
    end
  else
    Chef::Log.info "Create #{type} '#{name}'"
    converge_by "Create #{type} '#{name}'" do
      item.create
    end
  end
  save_res_info(save_resource_info, name, item.data)
end

action :create_if_missing do
  load_sdk
  klass = get_resource_named(type)
  c = build_client(client)
  item = klass.new(c, { name: name }.merge(data))
  if item.exists?
    Chef::Log.info("#{type} '#{name}' exists. Skipping")
    item.retrieve! if save_resource_info
  else
    Chef::Log.info "Create #{type} '#{name}'"
    converge_by "Create #{type} '#{name}'" do
      item.create
    end
  end
  save_res_info(save_resource_info, name, item.data)
end

action :delete do
  load_sdk
  klass = get_resource_named(type)
  c = build_client(client)
  item = klass.new(c, { name: name }.merge(data))
  if item.retrieve! # ~FC023
    converge_by "Delete #{type} '#{name}'" do
      item.delete
    end
  end
end
