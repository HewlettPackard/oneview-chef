require_relative './../../../spec_helper'

describe 'oneview_test::storage_system_refresh' do
  let(:resource_name) { 'storage_system' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }

  it 'refreshes it when it exists' do
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:[]).and_call_original
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:[]).with('refreshState').and_return('')
    expect_any_instance_of(base_sdk::StorageSystem).to receive(:set_refresh_state).with('RefreshPending').and_return(true)
    expect(real_chef_run).to refresh_oneview_storage_system('StorageSystem1')
  end

  it 'raises an error when it does not exist' do
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(base_sdk::StorageSystem).to_not receive(:set_refresh_state)
    expect { real_chef_run }.to raise_error(StandardError, /not found/)
  end
end

describe 'oneview_test_api500_synergy::storage_system_refresh' do
  let(:resource_name) { 'storage_system' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }

  it 'refreshes it when it exists' do
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::StorageSystem).to receive(:request_refresh).and_return(true)
    expect(real_chef_run).to refresh_oneview_storage_system('StorageSystem1')
  end

  it 'raises an error when it does not exist' do
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(base_sdk::StorageSystem).to_not receive(:request_refresh)
    expect { real_chef_run }.to raise_error(StandardError, /not found/)
  end
end
