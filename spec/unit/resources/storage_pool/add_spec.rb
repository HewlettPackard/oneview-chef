require_relative './../../../spec_helper'

describe 'oneview_test::storage_pool_add_with_ip' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  before :each do
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:create).and_return(true)
    # rubocop:disable Style/RescueModifier
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_call_original rescue nil # This is needed for some strange reason
    # rubocop:enable Style/RescueModifier
  end

  it 'accepts the storage_system_ip parameter' do
    expect(OneviewSDK::StorageSystem).to receive(:new).with(OneviewSDK::Client, credentials: { ip_hostname: '10.1.1.1' }).and_call_original
    expect_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:set_storage_system).with(OneviewSDK::StorageSystem)
    expect(real_chef_run).to add_oneview_storage_pool('StoragePool1')
  end
end

describe 'oneview_test::storage_pool_add_with_name' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  before :each do
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:create).and_return(true)
    # rubocop:disable Style/RescueModifier
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_call_original rescue nil # This is needed for some strange reason
    # rubocop:enable Style/RescueModifier
  end

  it 'accepts the storage_system_name parameter' do
    expect(OneviewSDK::StorageSystem).to receive(:new).with(OneviewSDK::Client, name: 'StorageSystem1').and_call_original
    expect_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:set_storage_system).with(OneviewSDK::StorageSystem)
    expect(real_chef_run).to add_oneview_storage_pool('StoragePool2')
  end
end
