require_relative './../../../spec_helper'

describe 'oneview_test::storage_system_add' do
  let(:resource_name) { 'storage_system' }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::StorageSystem).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_storage_system('StorageSystem1')
  end

  it 'updates it when it exists but not alike' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::StorageSystem).to receive(:update).and_return(true)
    expect(real_chef_run).to add_oneview_storage_system('StorageSystem1')
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::StorageSystem).to_not receive(:update)
    expect_any_instance_of(OneviewSDK::StorageSystem).to_not receive(:add)
    expect(real_chef_run).to add_oneview_storage_system('StorageSystem1')
  end
end
