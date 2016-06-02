Opscode::OneviewResourceBaseProperties.load(self)

resource_name :oneview_fc_network

default_action :create

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :create do
  create_or_update
end

action :create_if_missing do
  create_if_missing
end

action :delete do
  delete
end
