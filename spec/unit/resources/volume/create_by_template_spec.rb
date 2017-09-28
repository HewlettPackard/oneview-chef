require_relative './../../../spec_helper'

describe 'oneview_test::volume_create_by_template' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK }
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

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::Volume }
  let(:target_provider) { OneviewCookbook::API500::Synergy::VolumeProvider }

  it 'creates it when it does not exist' do
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect(base_sdk::StoragePool).to_not receive(:find_by)
    expect_any_instance_of(target_class).to receive(:set_storage_volume_template).and_return(true)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume('VOL2')
  end
end
