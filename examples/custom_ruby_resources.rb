# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# =======================================================================================

# If you find that this cookbook does not provide a resource you need, you can easily
# extend the functionality of this cookbook using the libraries it provides. Note that
# this is a more advanced usage and requires a deeper understanding of Chef, Ruby, and
# the OneView SDK for Ruby.

# The very first thing we need to do is make sure that the SDK is loaded, giving us access
# to its namespace & classes:
OneviewCookbook::Helper.load_sdk(self)

# Now we can use the SDK classes, such as the Client class:
my_client = OneviewSDK::Client.new(
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
)

# Since Chef recipes should not just be action scripts, we still need to use the Chef
# model of each configuration item being an idempotent resource definition. Chef provides
# a ruby_block resource that allows us to use pure ruby to define our own Chef resource.

# Example: make sure that hardware setup access is disabled
# Note that, if possible, we should always add an only_if or not_if block to the resource
# to make the resource idempotent. In this example, Chef will only run the main action
# block if the only_if block returns true.
ruby_block 'disable hardware setup access' do
  block do
    resp = my_client.rest_post('/rest/logindomains/global-settings/hardware-setup-access', body: false)
    my_client.response_handler(resp)
  end
  only_if do
    resp = my_client.rest_get('/rest/logindomains/global-settings/hardware-setup-access')
    my_client.response_handler(resp)['technicianEnabled']
  end
end

# There are also a few other helper methods that this cookbook provides to make it easier
# to do custom things. Here are a few (use these inside a custom ruby_block resource):
ruby_block 'compare resources' do
  block do
    vol1 = OneviewCookbook::Helper.load_resource(my_client, type: 'Volume', id: 'Vol1')
    vol2 = OneviewCookbook::Helper.load_resource(my_client, type: 'Volume', id: 'Vol2')
    diff = OneviewCookbook::Helper.get_diff(vol1.data, vol2.data)
    puts diff
  end
end
