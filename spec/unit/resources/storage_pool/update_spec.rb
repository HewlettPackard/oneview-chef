require_relative './../../../spec_helper'

describe 'oneview_test_api500_synergy::storage_pool_update' do
  let(:resource_name) { 'storage_pool' }
  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:provider_class) { OneviewCookbook::API500::Synergy::StoragePoolProvider }
  include_context 'chef context'

  before(:each) do
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(provider_class).to receive(:load_resource).with(:StorageSystem, anything).and_return(base_sdk::StorageSystem.new(client500, uri: '/sotrage-system/1'))
  end

  it 'raises an error if it does not exist' do
    expect_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(StandardError, /not found/)
  end

  it 'does nothing when it is already up to date' do
    expect_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(provider_class).to receive(:update_manage_state).and_return(true)
    allow_any_instance_of(base_sdk::StoragePool).to receive(:like?).and_return(true)
    expect_any_instance_of(base_sdk::StoragePool).to_not receive(:update)
    expect(real_chef_run).to update_oneview_storage_pool('StoragePool')
  end

  it 'updates it when its outdated' do
    expect_any_instance_of(base_sdk::StoragePool).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(provider_class).to receive(:update_manage_state).and_return(true)
    allow_any_instance_of(base_sdk::StoragePool).to receive(:like?).and_return(false)
    expect_any_instance_of(base_sdk::StoragePool).to receive(:update)
    expect(real_chef_run).to update_oneview_storage_pool('StoragePool')
  end
end
