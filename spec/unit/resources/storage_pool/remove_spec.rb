require_relative './../../../spec_helper'

describe 'oneview_test::storage_pool_remove' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  it 'removes it when it exists' do
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::StoragePool).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_storage_pool('StoragePool1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(OneviewSDK::StoragePool).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::StoragePool).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_storage_pool('StoragePool1')
  end
end
