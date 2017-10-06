require_relative './../../../spec_helper'

describe 'oneview_test::volume_create' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'
  include_context 'shared context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API200::VolumeProvider }
  let(:storage_system_class) { base_sdk::StorageSystem }
  let(:storage_pool_class) { base_sdk::StoragePool }
  let(:storage_system_data) { { credentials: { ip_hostname: 'StorageSystem1' }, name: 'StorageSystem1' } }
  let(:storage_system) { storage_system_class.new(@client,  credentials: { ip_hostname: 'StorageSystem1' }, name: 'StorageSystem1', uri: '/rest/storage-systems/1') }

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:set_storage_volume_template)
    expect(storage_system_class).to receive(:new).with(instance_of(OneviewSDK::Client), storage_system_data).and_return(storage_system)
    expect_any_instance_of(target_class).to receive(:set_storage_system).with(storage_system).and_return(true)
    expect(storage_pool_class).to receive(:new).with(instance_of(OneviewSDK::Client), name: 'Pool1', storageSystemUri: '/rest/storage-systems/1')
    expect_any_instance_of(target_class).to receive(:set_storage_pool).and_return(true)
    expect(storage_pool_class).to receive(:new).with(instance_of(OneviewSDK::Client), name: 'Pool2', storageSystemUri: '/rest/storage-systems/1')
    expect_any_instance_of(target_class).to receive(:set_snapshot_pool).and_return(true)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL1')
  end
end

describe 'oneview_test_api500_synergy::volume_create' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'
  include_context 'shared context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API500::Synergy::VolumeProvider }
  let(:storage_system_class) { base_sdk::StorageSystem }
  let(:storage_pool_class) { base_sdk::StoragePool }
  let(:storage_pool) { storage_pool_class.new(@client, uri: '/rest/storage-pools/1') }

  before do
    allow_any_instance_of(target_provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(target_provider).to receive(:load_resource).with(:StorageSystem, anything, anything).and_return('/rest/storage-systems/1')
  end

  it 'creates VOL1 when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:set_storage_volume_template)
    expect(storage_pool_class).to receive(:new).with(instance_of(OneviewSDK::Client), name: 'Pool1', storageSystemUri: '/rest/storage-systems/1').and_return(storage_pool)
    expect_any_instance_of(target_class).to receive(:set_storage_pool).and_call_original
    expect(storage_pool_class).to receive(:new).with(instance_of(OneviewSDK::Client), name: 'Pool2', storageSystemUri: '/rest/storage-systems/1').and_return(storage_pool)
    expect_any_instance_of(target_class).to receive(:set_snapshot_pool).and_return(true)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL1')
  end
end
