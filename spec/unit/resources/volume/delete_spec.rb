require_relative './../../../spec_helper'

describe 'oneview_test::volume_delete' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  it 'removes it if it does exist' do
    expect_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Volume).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end

  it 'does nothing if it does not exist' do
    expect_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::Volume).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_volume('VOL1')
  end
end
