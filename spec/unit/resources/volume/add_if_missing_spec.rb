require_relative './../../../spec_helper'

describe 'oneview_test_api500_synergy::volume_add_if_missing' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API500::Synergy::VolumeProvider }
  let(:storage_system) { base_sdk::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1') }

  before do
    allow_any_instance_of(target_provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(target_provider).to receive(:load_resource).with(:StorageSystem, anything, anything).and_return(storage_system)
  end

  it 'creates VOL1 when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_volume_if_missing('VOL1')
  end

  it 'does nothing when VOL1 exists' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(true)
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to_not receive(:add)
    expect(real_chef_run).to add_oneview_volume_if_missing('VOL1')
  end
end
