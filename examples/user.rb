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

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# Example: Create or update a user account
# In this example we'll only set the required data. See the next example for
# a more-complete set of options
oneview_user 'User1' do
  client my_client
  data(
    password: 'secret123',
    roles: ['Infrastructure administrator'] # Full access
  )
end

# Example: Create or update another user account (with more options this time)
oneview_user 'User2' do
  client my_client
  data(
    password: 'secret123',
    emailAddress: 'john.doe@example.com',
    officePhone: '333-333-3333',
    mobilePhone: '444-444-4444',
    fullName: 'John Doe',
    enabled: true,
    roles: ['Network administrator', 'Server administrator']
  )
end

# Example: Create a user account only if it does not exist (no updates will be made)
oneview_user 'User3' do
  client my_client
  data(
    password: 'secret123',
    emailAddress: 'jane.doe@example.com',
    officePhone: '333-333-3333',
    mobilePhone: '555-555-5555',
    fullName: 'Jane Doe',
    enabled: true,
    roles: ['Network administrator', 'Server administrator']
  )
  action :create_if_missing
end

# Example: Make sure a user accont does not exist
oneview_user 'User4' do
  client my_client
  action :delete
end

# Clean up the other use accounts:
(1..3).each do |i|
  oneview_user "Delete User#{i}" do
    client my_client
    data(userName: "User#{i}")
    action :delete
  end
end
