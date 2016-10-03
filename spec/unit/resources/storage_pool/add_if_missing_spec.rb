require_relative './../../../spec_helper'

describe 'oneview_test::storage_pool_add_if_missing_with_ip' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  it 'does not add if it already exists' do
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:set_storage_system).and_return(true)
    expect_any_instance_of(OneviewSDK::StoragePool).to_not receive(:add)
    expect(real_chef_run).to add_oneview_storage_pool_if_missing('StoragePool1')
  end

  it 'accepts the storage_system as ip' do
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    expect(OneviewSDK::StorageSystem).to receive(:new).with(OneviewSDK::Client, credentials: { ip_hostname: '10.1.1.1' }).and_call_original
    expect(OneviewSDK::StorageSystem).to_not receive(:new).with(OneviewSDK::Client, name: '10.1.1.1')
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:set_storage_system).with(OneviewSDK::StorageSystem)
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:add)
    expect(real_chef_run).to add_oneview_storage_pool_if_missing('StoragePool1')
  end
end

describe 'oneview_test::storage_pool_add_if_missing_with_name' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  it 'accepts the storage_system_name parameter' do
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    expect(OneviewSDK::StorageSystem).to receive(:new).with(OneviewSDK::Client, credentials: { ip_hostname: 'StorageSystem1' }).and_call_original
    expect(OneviewSDK::StorageSystem).to receive(:new).with(OneviewSDK::Client, name: 'StorageSystem1').and_call_original
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:set_storage_system).with(OneviewSDK::StorageSystem)
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:add)
    expect(real_chef_run).to add_oneview_storage_pool_if_missing('StoragePool2')
  end
end
