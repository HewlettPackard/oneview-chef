resource_name :fc_network

property :name, [String]
property :client, [Hash], required: true
property :data, [Hash]

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
