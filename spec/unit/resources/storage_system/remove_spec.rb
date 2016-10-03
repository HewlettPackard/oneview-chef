require_relative './../../../spec_helper'

describe 'oneview_test::storage_system_remove' do
  let(:resource_name) { 'storage_system' }
  include_context 'chef context'

  it 'removes it when it exists' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::StorageSystem).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_storage_system('StorageSystem1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::StorageSystem).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_storage_system('StorageSystem1')
  end
end
