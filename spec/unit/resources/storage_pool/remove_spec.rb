require_relative './../../../spec_helper'

describe 'oneview_test::storage_pool_remove' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:provider_class) { OneviewCookbook::API200::StoragePoolProvider }

  before(:each) do
    allow_any_instance_of(provider_class).to receive(:load_resource).with(:StorageSystem, anything).and_return('LoadedStorageSystem')
    allow_any_instance_of(base_sdk::StoragePool).to receive(:set_storage_system).with('LoadedStorageSystem').and_return(true)
  end

  it 'removes it when it exists' do
    allow_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::StoragePool).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_storage_pool('StoragePool1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(base_sdk::StoragePool).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_storage_pool('StoragePool1')
  end
end

describe 'oneview_test_api500_synergy::storage_pool_remove' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  let(:provider_class) { OneviewCookbook::API500::Synergy::StoragePoolProvider }

  it 'calls remove_from_management action' do
    allow(Chef::Log).to receive(:warn).and_call_original
    expect(Chef::Log).to receive(:warn).with(/remove_from_management/).and_return(true)
    expect_any_instance_of(provider_class).to receive(:remove_from_management).and_return(true)
    expect(real_chef_run).to remove_oneview_storage_pool('StoragePool')
  end
end
