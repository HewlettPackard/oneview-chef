resource_name :logical_interconnect_group

property :name, [String]
property :client, [Hash], required: true
property :data, [Hash]
property :interconnects, [Array]
property :uplink_sets, [Array]

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :create do
  load_sdk
  item = load_resource

  interconnects.each do |location|
    item.add_interconnect(location[:bay], location[:type])
  end

  uplink_sets.each do |uplink_info|
    up = OneviewSDK::LIGUplinkSet.new(item.client, uplink_info[:data])

    uplink_info[:networks].each do |network_name|
      net = case up[:networkType]
            when 'EthernetNetwork'
              OneviewSDK::EthernetNetwork.new(item.client, network_name)
            when 'FibreChannel'
              OneviewSDK::FCNetwork.new(item.client, network_name)
            else
              raise "Type #{up[:networkType]} not supported"
            end
      up.add_network(net)
    end

    uplink_info[:connections].each { |link| up.add_uplink(link[:bay], link[:port]) }

    item.add_uplink_set(up)
  end
  create_or_update
end

action :create_if_missing do
  create_if_missing
end

action :delete do
  delete
end
