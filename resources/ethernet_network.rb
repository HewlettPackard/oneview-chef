include Opscode::OneviewHelper

resource_name :ethernet_network

property :name, [String]
property :client, [Hash], required: true
property :data, [Hash]


action :create do
  c = build_client(client)
  new_resource.data['name'] ||= new_resource.name
  item = OneviewSDK::EthernetNetwork.new(c, new_resource.data)
  create_or_update(item)
end

action :delete do
  network = OneviewSDK::EthernetNetwork.new(new_resource.client, new_resource.data)
  network.retrieve!
  network.delete
end
