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


# Notes: In general, this is a more advanced resource that is meant to be used with caution.
# It may allow you to configure OneView resources that don't have their own Chef resource yet,
# but that resource must have a defined oneview-sdk class. This will make more sense as we look
# at some examples below, but note that there are some generic assumptions being made about how
# these resources can be interacted with. These assumptions include the availability of the
# :exists?, :retrieve!, :create, :update and :destroy methods. For resources that don't conform
# to those assumptions, see the custom_ruby_resources.rb example.

# Note that this client is not just a hash; it's a OneviewSDK::Client object. We'll need to use
# it in our examples below to interact with OneView and get some information we need.
OneviewCookbook::Helper.load_sdk(self)
my_client = OneviewSDK::Client.new(
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
)

# Example: Create a simple ServerProfileTemplate
# In this example we'll create/manage a ServerProfileTemplate. Since there is a
# OneviewSDK::ServerProfileTemplate class and it adheres to the assumptions mentioned above,
# we can use it with this generic oneview_resource. This will be about as basic as a
# ServerProfileTemplate as we can create, but any attributes listed in the API docs can go into
# the data property hash.
# Here we'll also use the my_client object to retrieve some related objects we need:
hw_type = OneviewSDK::ServerHardwareType.find_by(my_client, name: 'BL460c Gen8 1').first || raise('HW Type not found!')
enclosure_group = OneviewSDK::EnclosureGroup.find_by(my_client, name: 'Enclosure Group 1').first || raise('Enclosure Group not found!')

oneview_resource 'Chef-Template' do
  client my_client
  type :ServerProfileTemplate
  data(
    serverHardwareTypeUri: hw_type['uri'],
    enclosureGroupUri: enclosure_group['uri'],
    description: 'Template Created by Chef'
  )
end

# Example: Create a ServerProfile
# In this example we'll create/manage a ServerProfile. Since there is a OneviewSDK::ServerProfile
# class, and it adheres to the assumptions mentioned above, we can use it with this generic
# oneview_resource. Again, this will be a very basic ServerProfile, but any attributes listed in
# the API docs can go into the data property hash. Like the example above, we'll use the hw_type
# and enclosure_group objects we retrieved. We'll also retrieve a hardware uri to use.
existing_profile = OneviewSDK::ServerProfile.find_by(my_client, name: 'Chef-Server-Profile').first
if existing_profile
  hw_uri = existing_profile['serverHardwareUri']
else
  available_servers = OneviewSDK::ServerProfile.get_available_servers(
    my_client, { enclosure_group: enclosure_group, server_hardware_type: hw_type })
  hw_uri = available_servers.first['serverHardwareUri']
end

oneview_resource 'Chef-Server-Profile' do
  client my_client
  type :ServerProfile
  data(
    serverHardwareTypeUri: hw_type['uri'],
    enclosureGroupUri: enclosure_group['uri'],
    serverHardwareUri: hw_uri,
    description: 'Profile Created by Chef',
    boot: {
      manageBoot: true,
      order: %w(PXE CD Floppy USB HardDisk)
    }
  )
end

# Since resource info for all chef-managed resources gets saved as a node attribute, we can
# use that data later on. Here we'll just print out the uri of the profile we created, but more
# useful options for this data include using it to reference other resources and extract data from
# them to include in your data hash. For example, a volume could reference a volume template's uri.
log "print out Chef-Server-Profile's uri" do
  message lazy { "Chef-Server-Profile uri: #{node['oneview'][my_client.url]['Chef-Server-Profile']['uri']}" }
end
