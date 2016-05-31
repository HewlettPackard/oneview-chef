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
  create_or_update(item)
end

action :create_only do
  load_sdk
  c = build_client(client)
  item = OneviewSDK::FCNetwork.new(c, new_resource.data)
  item['name'] ||= new_resource.name
  create_only(item)
end

action :delete do
  load_sdk
  c = build_client(client)
  new_resource.data['name'] ||= new_resource.name
  network = OneviewSDK::FCNetwork.new(c, new_resource.data)
  network.retrieve!
  network.delete
end
