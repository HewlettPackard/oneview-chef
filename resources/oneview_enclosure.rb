Opscode::OneviewResourceBaseProperties.load(self)

resource_name :oneview_enclosure

default_action :create

property :enclosure_group

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :add do
  item = load_resource
  eg = OneviewSDK::EnclosureGroup.new(item.client, name: new_resource.enclosure_group)
  item.set_enclosure_group(eg)
  create_or_update(item)
end

action :remove do
  delete
end
