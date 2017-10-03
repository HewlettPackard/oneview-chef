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
#  base_sdk - The base sdk prefix of Oneview resources used in this test.
#    e.g: let(:base_sdk) { OneviewSDK::API200 }
#  target_class - Full name of the OneView resource to be tested
#  target_provider_class - Full name of the resource provider to be tested
#  target_match_method - Array with name of match method called and with the argument of the match method,
#    e.g: let(:target_match_method) { [:create_oneview_server_profile, 'ServerProfileName'] }
RSpec.shared_examples 'action :create #add_volume_attachments' do
  it 'should #add_volume_attachment' do
    allow_any_instance_of(target_class).to receive(:[]).with('name')
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    allow_any_instance_of(target_class).to receive(:create).and_return(true)
    allow_any_instance_of(base_sdk::Volume).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_provider_class)
      .to receive(:load_resource)
      .with(:Volume, name: 'Volume1')
      .and_call_original
    expect_any_instance_of(target_provider_class)
      .to receive(:load_resource)
      .with(:Volume, name: 'Volume2')
      .and_call_original
    expect_any_instance_of(target_class).to receive(:add_volume_attachment)
      .with(instance_of(base_sdk::Volume), 'attr_1' => 'attr 1')
    expect_any_instance_of(target_class).to receive(:add_volume_attachment)
      .with(instance_of(base_sdk::Volume), 'attr_2' => 'attr 2')
    expect_any_instance_of(target_class).to receive(:[]).twice.with('sanStorage').and_return({})
    expect_any_instance_of(base_sdk::StorageSystem).not_to receive(:retrieve!)
    expect_any_instance_of(base_sdk::StoragePool).not_to receive(:retrieve!)
    expect_any_instance_of(target_class).not_to receive(:create_volume_with_attachment)
    expect(real_chef_run).to public_send(*target_match_method)
  end
end

RSpec.shared_examples 'action :create #create_volume_attachments' do
  it 'should #add_volume_attachment' do
    allow_any_instance_of(target_class).to receive(:[]).with('name')
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    allow_any_instance_of(target_class).to receive(:create).and_return(true)
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_provider_class)
      .to receive(:load_resource)
      .with(:StorageSystem, { hostname: 'StorageSystem1', name: 'StorageSystem1' }, :uri)
      .and_call_original
    expect_any_instance_of(target_provider_class)
      .to receive(:load_resource)
      .with(:StorageSystem, { hostname: 'StorageSystem2', name: 'StorageSystem2' }, :uri)
      .and_call_original
    expect(base_sdk::StorageSystem).to receive(:new)
      .and_return(base_sdk::StorageSystem.new(client, uri: 'fake/StorageSystem1'), base_sdk::StorageSystem.new(client, uri: 'fake/StorageSystem2'))
    expect_any_instance_of(target_provider_class)
      .to receive(:load_resource)
      .with(:StoragePool, name: 'StoragePool1', storageSystemUri: 'fake/StorageSystem1')
      .and_call_original
    expect_any_instance_of(target_provider_class)
      .to receive(:load_resource)
      .with(:StoragePool, name: 'StoragePool2', storageSystemUri: 'fake/StorageSystem2')
      .and_call_original
    expect_any_instance_of(target_class).to receive(:create_volume_with_attachment)
      .with(instance_of(base_sdk::StoragePool), { 'name' => 'Volume1' }, 'attr_1' => 'attr 1')
    expect_any_instance_of(target_class).to receive(:create_volume_with_attachment)
      .with(instance_of(base_sdk::StoragePool), { 'name' => 'Volume2' }, 'attr_2' => 'attr 2')
    expect_any_instance_of(target_class).to receive(:[]).twice.with('sanStorage').and_return({})
    expect_any_instance_of(base_sdk::Volume).not_to receive(:retrieve!)
    expect_any_instance_of(target_class).not_to receive(:add_volume_attachment)
    expect(real_chef_run).to public_send(*target_match_method)
  end
end

# NOTE:
# This shared example requires the following variables:
#  target_class - Full name of the OneView resource to be tested
#  target_match_method - Array with name of match method called and with the argument of the match method,
#    e.g: let(:target_match_method) { [:create_oneview_server_profile, 'ServerProfileName'] }
RSpec.shared_examples 'action :create #create_volume_attachments with wrong data' do
  it 'should #add_volume_attachment' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).not_to receive(:create_volume_with_attachment)
    expect_any_instance_of(target_class).not_to receive(:add_volume_attachment)
    expect { real_chef_run }.to raise_error(StandardError, /specify the 'volume' or 'volume_data' inside 'volume_attachments'/)
  end
end
