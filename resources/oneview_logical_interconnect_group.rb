Opscode::OneviewResourceBaseProperties.load(self)

property :interconnects, [Array], default: []
property :uplink_sets, [Array], default: []

resource_name :oneview_logical_interconnect_group

default_action :create

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
      net = nil
      case up[:networkType]
      when 'Ethernet'
        net = OneviewSDK::EthernetNetwork.new(item.client, name: network_name)
      when 'FibreChannel'
        net = OneviewSDK::FCNetwork.new(item.client, name: network_name)
      else
        raise "Type #{up[:networkType]} not supported"
      end
      raise "#{up[:networkType]} #{network_name} not found" unless net.retrieve!
      up.add_network(net)
    end

    uplink_info[:connections].each { |link| up.add_uplink(link[:bay], link[:port]) }

    item.add_uplink_set(up)
  end
  create_or_update(item)
end

action :create_if_missing do
  create_if_missing
end

action :delete do
  delete
end
