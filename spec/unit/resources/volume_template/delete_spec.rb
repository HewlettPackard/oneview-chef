require_relative './../../../spec_helper'

describe 'oneview_test::volume_template_delete' do
  let(:resource_name) { 'volume_template' }
  include_context 'chef context'

  it 'deletes it when it exists' do
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_volume_template('VolumeTemplate1')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::VolumeTemplate).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_volume_template('VolumeTemplate1')
  end
end
