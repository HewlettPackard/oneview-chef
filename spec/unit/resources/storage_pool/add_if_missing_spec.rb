require_relative './../../../spec_helper'

describe 'oneview_test::storage_pool_add_if_missing_with_ip' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:provider_class) { OneviewCookbook::API200::StoragePoolProvider }

  before(:each) do
    allow_any_instance_of(provider_class).to receive(:load_resource).with(:StorageSystem, anything).and_return('LoadedStorageSystem')
    allow_any_instance_of(base_sdk::StoragePool).to receive(:set_storage_system).with('LoadedStorageSystem').and_return(true)
  end

  it 'does not add if it already exists' do
    allow_any_instance_of(base_sdk::StoragePool).to receive(:exists?).and_return(true)
    allow_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::StoragePool).to_not receive(:add)
    expect(real_chef_run).to add_oneview_storage_pool_if_missing('StoragePool1')
  end

  it 'accepts the storage_system as ip and adds it' do
    allow_any_instance_of(base_sdk::StoragePool).to receive(:exists?).and_return(false)
    allow_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(base_sdk::StoragePool).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_storage_pool_if_missing('StoragePool1')
  end
end

describe 'oneview_test_api500_synergy::storage_pool_add_if_missing' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:provider_class) { OneviewCookbook::API500::Synergy::StoragePoolProvider }

  it 'calls add_for_management action' do
    allow(Chef::Log).to receive(:warn).and_call_original
    expect(Chef::Log).to receive(:warn).with(/add_for_management/).and_return(true)
    expect_any_instance_of(provider_class).to receive(:add_for_management).and_return(true)
    expect(real_chef_run).to add_oneview_storage_pool_if_missing('StoragePool')
  end
end
