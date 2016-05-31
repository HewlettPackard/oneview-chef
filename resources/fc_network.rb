include Opscode::OneviewHelper

resource_name :fc_network

property :name, [String]
property :client, [Hash], required: true
property :data, [Hash]


action :create do
  load_sdk
  c = build_client(client)
  item = OneviewSDK::FCNetwork.new(c, new_resource.data)
  item['name'] ||= new_resource.name
  converge_by "Create or Update #{resource_name} '#{name}'" do
    create_or_update(item)
  end
end

action :create_only do
  load_sdk
  c = build_client(client)
  item = OneviewSDK::FCNetwork.new(c, new_resource.data)
  item['name'] ||= new_resource.name
  converge_by "Create Only #{resource_name} '#{name}'" do
    create_only(item)
  end
end

action :delete do
  load_sdk
  c = build_client(client)
  item = OneviewSDK::FCNetwork.new(c, new_resource.data)
  item['name'] ||= new_resource.name
  converge_by "Delete #{resource_name} '#{name}'" do
    item.retrieve!
    item.delete
  end
end
