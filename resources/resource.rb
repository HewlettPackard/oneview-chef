Opscode::OneviewResourceBaseProperties.load(self)
property :type, [String, Symbol], required: true # Additional type property

default_action :create

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :create do
  item = load_resource
  create_or_update(item)
end

action :create_if_missing do
  item = load_resource
  create_if_missing(item)
  load_sdk
end

action :delete do
  item = load_resource
  delete(item)
end
