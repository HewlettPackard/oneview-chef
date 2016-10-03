# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

OneviewCookbook::ResourceBaseProperties.load(self)

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase

  def update_connection_template(item, bandwidth)
    bandwidth = convert_keys(bandwidth, :to_s)
    connection_template = OneviewSDK::ConnectionTemplate.new(item.client, uri: item['connectionTemplateUri'])
    connection_template.retrieve!
    if connection_template.like? bandwidth
      Chef::Log.info("#{resource_name} '#{name}' connection template is up to date")
    else
      converge_by "Update #{resource_name} '#{name}' connection template settings" do
        connection_template.update(bandwidth)
      end
    end
  end
end

action :create do
  item = load_resource
  bandwidth = item.data.delete('bandwidth')
  create_or_update(item)
  update_connection_template(item, bandwidth: bandwidth) if bandwidth
end

action :create_if_missing do
  item = load_resource
  bandwidth = item.data.delete('bandwidth')
  created = create_if_missing(item)
  update_connection_template(item, bandwidth: bandwidth) if bandwidth && created
end

action :reset_connection_template do
  item = load_resource
  item.retrieve!
  update_connection_template(item, bandwidth: OneviewSDK::ConnectionTemplate.get_default(item.client)['bandwidth'])
end

action :delete do
  delete
end

action :bulk_create do
  load_sdk
  connection = build_client(client)
  formatted_data = convert_keys(data, :to_sym)
  formatted_data[:namePrefix] ||= name
  converge_by "Create #{resource_name} '#{name}' within the range #{formatted_data[:vlanIdRange]}" do
    OneviewSDK::EthernetNetwork.bulk_create(connection, formatted_data)
  end
end
