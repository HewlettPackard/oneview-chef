require_relative './../../../spec_helper'

describe 'oneview_test::volume_template_create_if_missing' do
  let(:resource_name) { 'volume_template' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:target_class) { base_sdk::VolumeTemplate }
  let(:target_provider) { OneviewCookbook::API200::VolumeTemplateProvider }

  before do
    allow_any_instance_of(target_provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(target_provider)
      .to receive(:load_resource)
      .with(:StorageSystem, anything)
      .and_return(base_sdk::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1'))
    allow_any_instance_of(target_provider)
      .to receive(:load_resource)
      .with(:StoragePool, anything)
      .and_return(base_sdk::StoragePool.new(client, uri: 'rest/sp1'))
  end

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume_template_if_missing('VolumeTemplate1')
  end

  it 'does nothing when it exists' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(true)
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:exists?).and_return(true)
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to_not receive(:create)
    expect(real_chef_run).to create_oneview_volume_template_if_missing('VolumeTemplate1')
  end
end

describe 'oneview_test_api500_synergy::volume_template_create_if_missing' do
  let(:resource_name) { 'volume_template' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::VolumeTemplate }
  let(:target_provider) { OneviewCookbook::API500::Synergy::VolumeTemplateProvider }

  before do
    allow_any_instance_of(target_provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(target_provider)
      .to receive(:load_resource)
      .with(:StorageSystem, anything)
      .and_return(base_sdk::StorageSystem.new(client, name: 'StorageSystem1', uri: '/rest/storage-systems/1'))
    allow_any_instance_of(target_provider)
      .to receive(:load_resource)
      .with(:StoragePool, anything)
      .and_return(base_sdk::StoragePool.new(client, uri: 'rest/sp1'))
    allow_any_instance_of(base_sdk::StorageSystem).to receive(:get_templates).and_return([{ 'isRoot' => false }, { 'isRoot' => true }])
    expect_any_instance_of(target_class).to receive(:set_root_template)
    expect_any_instance_of(target_class).to receive(:set_default_value)
  end

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(target_class).to receive(:create)
    expect(real_chef_run).to create_oneview_volume_template_if_missing('VolumeTemplate1')
  end

  it 'does nothing when it exists' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(true)
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).not_to receive(:create)
    expect(real_chef_run).to create_oneview_volume_template_if_missing('VolumeTemplate1')
  end

  it 'set_root_template method should be called before set_default_value method of Oneview resource VolumeTemplate' do
    item = target_class.new(client, {})
    allow(item).to receive(:exists?).and_return(true)
    allow(item).to receive(:retrieve!).and_return(true)
    allow(target_class).to receive(:new).and_return(item)
    expect(item).to receive(:set_root_template).ordered
    expect(item).to receive(:set_default_value).ordered
    expect(real_chef_run).to create_oneview_volume_template_if_missing('VolumeTemplate1')
  end
end
