require_relative './../../../spec_helper'

describe 'oneview_test::volume_create' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  before :each do
    allow(OneviewSDK::StoragePool).to receive(:find_by).and_return(
      [
        OneviewSDK::StoragePool.new(client, name: 'Pool1', uri: '/rest/fake', storageSystemUri: '/rest/storage-systems/1'),
        OneviewSDK::StoragePool.new(client, name: 'Pool2', uri: '/rest/fake', storageSystemUri: '/rest/storage-systems/1'),
      ]
    )
    allow(OneviewSDK::StorageSystem).to receive(:find_by).with(kind_of(OneviewSDK::Client), name: 'StorageSystem1')
      .and_return([OneviewSDK::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1')])
    allow(OneviewSDK::StorageSystem).to receive(:find_by).with(kind_of(OneviewSDK::Client), credentials: { ip_hostname: 'StorageSystem1' })
      .and_return([])
    allow_any_instance_of(OneviewSDK::Volume).to receive(:exists?).and_return(false)
  end

  it 'searches for the storage_pool, snapshot_pool, and volume_template' do
    expect_any_instance_of(OneviewSDK::Volume).to receive(:set_snapshot_pool).and_return(true)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:set_storage_volume_template).and_return(true)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:set_storage_system).and_return(true)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL1')
  end
end
