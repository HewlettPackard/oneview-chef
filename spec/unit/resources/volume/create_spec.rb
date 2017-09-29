require_relative './../../../spec_helper'

describe 'oneview_test::volume_create' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API200::VolumeProvider }

  before do
    allow(base_sdk::StorageSystem).to receive(:retrieve!).and_return(base_sdk::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1'))
    allow_any_instance_of(target_provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(target_provider).to receive(:load_resource).with(:StoragePool, anything, anything).and_return('/rest/storage-systems/1')
  end

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:set_storage_volume_template)
    expect_any_instance_of(target_class).to receive(:set_storage_system).and_return(true)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL1')
  end
end

describe 'oneview_test_api500_synergy::volume_create' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API500::Synergy::VolumeProvider }
  let(:storage_system) { base_sdk::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1') }

  before do
    allow_any_instance_of(target_provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(target_provider).to receive(:load_resource).with(:StorageSystem, anything, anything).and_return(storage_system)
    allow_any_instance_of(target_provider).to receive(:load_resource).with(:StoragePool, anything, anything).and_return('/rest/storage-systems/1')
  end

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:set_storage_volume_template)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL1')
  end
end
