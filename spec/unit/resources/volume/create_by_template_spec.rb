require_relative './../../../spec_helper'

describe 'oneview_test::volume_create_by_template' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  before :each do
    allow_any_instance_of(OneviewSDK::Volume).to receive(:exists?).and_return(false)
  end

  it 'searches for the storage_pool, snapshot_pool, and volume_template' do
    expect(OneviewSDK::StoragePool).to_not receive(:find_by)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:set_storage_volume_template).and_return(true)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL2')
  end
end
