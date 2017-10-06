require_relative './../../../spec_helper'

describe 'oneview_test::volume_create_by_template' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API200::VolumeProvider }

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect(base_sdk::StoragePool).to_not receive(:find_by)
    expect_any_instance_of(target_class).to receive(:set_storage_volume_template).and_return(true)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL2')
  end
end

describe 'oneview_test_api500_synergy::volume_create_by_template' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'
  include_context 'shared context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API500::Synergy::VolumeProvider }
  let(:volume_template_class) { base_sdk::VolumeTemplate }
  let(:storage_pool_class) { base_sdk::StoragePool }
  let(:template_options) do
    {
      'uri' => '/rest/storage-volume-templates/1',
      'name' => 'Template1',
      'family' => 'StoreServ',
      'storagePoolUri' => '/rest/storage-pools/1',
      'properties' => {
        'snapshotPool' => { 'default' => '/rest/storage-pools/2' }
      }
    }
  end
  let(:template) { volume_template_class.new(@client, template_options) }
  let(:storage_pool) { storage_pool_class.new(@client, uri: template_options['storagePoolUri']) }

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect(volume_template_class).to receive(:new).with(instance_of(OneviewSDK::Client), name: template_options['name']).and_return(template)
    expect_any_instance_of(target_class).to receive(:set_storage_volume_template).and_return(true)
    expect(storage_pool_class).to receive(:new).with(instance_of(OneviewSDK::Client), uri: template_options['storagePoolUri']).and_return(storage_pool)
    expect_any_instance_of(target_class).to receive(:set_storage_pool).and_call_original
    expect(storage_pool_class).to receive(:new).with(instance_of(OneviewSDK::Client), uri: template_options['properties']['snapshotPool']['default']).and_return(storage_pool)
    expect_any_instance_of(target_class).to receive(:set_snapshot_pool).and_return(true)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL2')
  end
end
