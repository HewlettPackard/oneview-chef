Opscode::OneviewResourceBaseProperties.load(self)

default_action :create

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :add do
  item = load_resource
  item.data.delete('name')
  create_if_missing(item)
end

action :edit do
  item = load_resource
  item.data.delete('name') if item['credentials'] && item['credentials'][:ip_hostname]
  item.retrieve!
  update(item)
end

action :remove do
  item = load_resource
  item.data.delete('name') if item['credentials'] && item['credentials'][:ip_hostname]
  item.retrieve!
  delete(item)
end
