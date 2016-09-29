require_relative './../../../spec_helper'

describe 'oneview_test::storage_system_add_if_missing' do
  let(:resource_name) { 'storage_system' }
  include_context 'chef context'

  it 'storage system does not exist' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::StorageSystem).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_storage_system_if_missing('StorageSystem1')
  end

  it 'storage system already exists' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::StorageSystem).to_not receive(:add)
    expect(real_chef_run).to add_oneview_storage_system_if_missing('StorageSystem1')
  end
end
