require_relative './../../../spec_helper'

describe 'oneview_test::volume_delete' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::Volume }

  it 'removes it if it does exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end

  it 'does nothing if it does not exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end
end

describe 'oneview_test_api500_synergy::volume_delete' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API500::Synergy::Volume }

  it 'removes it if it does exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:delete).with(:all).and_return(true)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end

  it 'does nothing if it does not exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end
end

describe 'oneview_test_api500_synergy::volume_delete_from_appliance_only' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API500::Synergy::Volume }

  it 'removes it if it does exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:delete).with(:oneview).and_return(true)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end

  it 'does nothing if it does not exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end
end
