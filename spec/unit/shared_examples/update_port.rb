# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE:
# This shared example requires the following variables:
#  target_class - Full name of the OneView resource to be tested
#  target_match_method - Array with name of match method called and with the argument of the match method,
#    e.g: let(:target_match_method) { [:add_oneview_enclosure_to_scopes, 'EnclosureName'] }

RSpec.shared_examples 'action :update_port' do
  it 'updates the port' do
    ports = [
      { 'name' => '1.1', 'enabled' => false },
      { 'name' => '1.2', 'enabled' => true }
    ]
    item = target_class.new(@client, uri: '/rest/fake', ports: ports)
    allow(target_class).to receive(:find_by).and_return([item])
    expect_any_instance_of(target_class).to receive(:update_port).with('1.1', anything).and_return(true)
    expect(real_chef_run).to public_send(*target_match_method)
  end

  it 'leaves it as is since it is up to date' do
    ports = [
      { 'name' => '1.1', 'enabled' => true },
      { 'name' => '1.2', 'enabled' => true }
    ]
    item = target_class.new(@client, uri: '/rest/fake', ports: ports)
    allow(target_class).to receive(:find_by).and_return([item])
    expect_any_instance_of(target_class).to_not receive(:update_port)
    expect(real_chef_run).to public_send(*target_match_method)
  end

  it 'fails when trying to update an unexistant port' do
    ports = [
      { 'name' => '1.2', 'enabled' => true },
      { 'name' => '1.3', 'enabled' => true }
    ]
    item = target_class.new(@client, uri: '/rest/fake', ports: ports)
    allow(target_class).to receive(:find_by).and_return([item])
    expect { real_chef_run }.to raise_error(RuntimeError, /Could not find port/)
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end

RSpec.shared_examples 'action :update_port #update_port with an invalid port' do
  it 'fails if port_options property is not set' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect { real_chef_run }.to raise_error(RuntimeError, /Unspecified property: 'port_options'/)
  end
end
