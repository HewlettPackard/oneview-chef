require_relative './../../../spec_helper'

describe 'oneview_test::resource_delete' do
  let(:resource_name) { 'resource' }
  include_context 'chef context'

  it 'creates EthernetNetwork2 when it does not exist' do
    expect_any_instance_of(OneviewSDK::Resource).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Resource).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_resource('EthernetNetwork3')
  end

  it 'does nothing when EthernetNetwork2 does not exist' do
    expect_any_instance_of(OneviewSDK::Resource).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::Resource).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_resource('EthernetNetwork3')
  end
end
