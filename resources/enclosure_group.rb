Opscode::OneviewResourceBaseProperties.load(self)

property :logical_interconnect_group

default_action :create

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :create do
  item = load_resource
  if new_resource.logical_interconnect_group
    lig = OneviewSDK::LogicalInterconnectGroup.new(item.client, name: new_resource.logical_interconnect_group)
    item.add_logical_interconnect_group(lig)
  end
  create_or_update(item)
end

action :delete do
  delete
end
