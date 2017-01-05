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

OneviewCookbook::Helper.load_sdk(self)
OneviewCookbook::Helper.load_attributes(self)

property :spp_name, String
property :spp_file, String
property :hotfixes_names, Array
property :hotfixes_files, Array

default_action :add

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase

  def load_firmware(filename = nil)
    c = build_client(client)
    item = OneviewSDK::FirmwareDriver.new(c, name: name)
    if item.exists?
      item.retrieve!
      return item
    end
    filename ||= name
    filename = ::File.basename(filename, ::File.extname(filename)).tr('.', '_')
    firmware_list = OneviewSDK::FirmwareDriver.find_by(c, {})
    firmware_list.find { |fw| filename == fw['resourceId'] }
  end
end

action :add do
  item = load_firmware
  if item
    Chef::Log.info "#{resource_name} '#{name}' is already up to date."
  else
    c = build_client(client)
    converge_by "Add #{resource_name} '#{name}'" do
      OneviewSDK::FirmwareBundle.add(c, name)
    end
  end
end

action :create_custom_spp do
  raise "Unspecified property: 'spp_name' or 'spp_file'. Please set it before attempting this action." unless spp_name || spp_file
  unless hotfixes_names || hotfixes_files
    raise "Unspecified property: 'hotfixes_names' or 'hotfixes_files'. Please set it before attempting this action."
  end
  c = build_client(client)
  item = OneviewSDK::FirmwareDriver.new(c, name: name)
  if item.exists?
    Chef::Log.info("#{resource_name} '#{name}' is up to date")
  else
    item['customBaselineName'] = name
    if spp_name
      spp = OneviewSDK::FirmwareDriver.new(c, name: spp_name)
      spp.retrieve!
    else
      spp = load_firmware(spp_file)
    end
    item['baselineUri'] = spp['uri']
    item['hotfixUris'] = []
    if hotfixes_names
      hotfixes_names.each do |hotfix|
        temp = OneviewSDK::FirmwareDriver.new(c, name: hotfix)
        temp.retrieve!
        item['hotfixUris'] << temp['uri'] if temp['uri']
      end
    else
      hotfixes_files.each do |hotfix|
        temp = load_firmware(hotfix)
        item['hotfixUris'] << temp['uri'] if temp['uri']
      end
    end

    Chef::Log.info "Created custom #{resource_name} '#{name}'"
    converge_by "Created custom #{resource_name} '#{name}'" do
      item.data.delete('name')
      item.create
    end
  end
end

action :remove do
  item = load_firmware
  remove(item) if item
end
