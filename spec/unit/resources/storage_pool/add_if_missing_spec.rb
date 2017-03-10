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
    fake_storage_system = Object.new
    allow_any_instance_of(OneviewCookbook::API200::StoragePoolProvider).to receive(:load_resource)
      .with(:StorageSystem, credentials: { ip_hostname: '10.1.1.1' }, name: '10.1.1.1').and_return(fake_storage_system)
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:set_storage_system).with(fake_storage_system)
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_storage_pool_if_missing('StoragePool1')
  end
end
