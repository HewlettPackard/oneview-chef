require_relative './../../../spec_helper'

describe 'oneview_test::volume_template_create' do
  let(:resource_name) { 'volume_template' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    allow_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:retrieve!).and_return(false)
    allow_any_instance_of(OneviewCookbook::API200::VolumeTemplateProvider).to receive(:load_resource).and_call_original
    allow_any_instance_of(OneviewCookbook::API200::VolumeTemplateProvider)
      .to receive(:load_resource)
      .with(:StorageSystem, anything)
      .and_return(OneviewSDK::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1'))
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::StoragePool).to receive(:find_by)
      .and_return([OneviewSDK::StoragePool.new(client, uri: 'rest/sp1')])
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume_template('VolumeTemplate1')
  end

  it 'updates it when it exists but not alike' do
    allow_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewCookbook::API200::VolumeTemplateProvider).to receive(:load_resource).and_call_original
    allow_any_instance_of(OneviewCookbook::API200::VolumeTemplateProvider)
      .to receive(:load_resource)
      .with(:StorageSystem, anything)
      .and_return(OneviewSDK::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1'))
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::StoragePool).to receive(:find_by)
      .and_return([OneviewSDK::StoragePool.new(client, uri: 'rest/sp1')])
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_volume_template('VolumeTemplate1')
  end

  it 'does nothing when it exists and its alike' do
    allow_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewCookbook::API200::VolumeTemplateProvider).to receive(:load_resource).and_call_original
    allow_any_instance_of(OneviewCookbook::API200::VolumeTemplateProvider)
      .to receive(:load_resource)
      .with(:StorageSystem, anything)
      .and_return(OneviewSDK::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1'))
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::StoragePool).to receive(:find_by)
      .and_return([OneviewSDK::StoragePool.new(client, uri: 'rest/sp1')])
    allow_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to_not receive(:create)
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to_not receive(:update)
    expect(real_chef_run).to create_oneview_volume_template('VolumeTemplate1')
  end
end
