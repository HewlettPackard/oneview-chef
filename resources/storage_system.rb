Opscode::OneviewResourceBaseProperties.load(self)

default_action :create

action_class do
  include Opscode::OneviewHelper
  include Opscode::OneviewResourceBase
end

action :add do
  create_if_missing
end

action :edit do
  update
end

action :remove do
  delete
end
