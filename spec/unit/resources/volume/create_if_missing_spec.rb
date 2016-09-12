require_relative './../../../spec_helper'

describe 'oneview_test::volume_create_if_missing' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  it 'creates VOL1 when it does not exist' do
    expect_any_instance_of(OneviewSDK::Volume).to receive(:exists?).at_least(:once).and_return(false)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_volume_if_missing('VOL1')
  end

  it 'does nothing when VOL1 exists' do
    expect_any_instance_of(OneviewSDK::Volume).to receive(:exists?).at_least(:once).and_return(true)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Volume).to_not receive(:create)
    expect(real_chef_run).to create_oneview_volume_if_missing('VOL1')
  end
end
