require_relative './../../../spec_helper'

describe 'oneview_test::storage_system_edit_credentials' do
  let(:resource_name) { 'storage_system' }
  include_context 'chef context'

  it 'does nothing when storage system does not exists' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::StorageSystem).to_not receive(:update).and_return(true)
    expect(real_chef_run).to edit_oneview_storage_system_credentials('StorageSystem1')
  end

  it 'edits storage system credentials when it exists' do
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::StorageSystem).to receive(:update).and_return(true)
    expect(real_chef_run).to edit_oneview_storage_system_credentials('StorageSystem1')
  end
end
