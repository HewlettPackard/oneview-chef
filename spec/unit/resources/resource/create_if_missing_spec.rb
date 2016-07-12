require_relative './../../../spec_helper'

describe 'oneview_test::resource_create_if_missing' do
  let(:resource_name) { 'resource' }
  include_context 'chef context'

  it 'creates EthernetNetwork2 when it does not exist' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_resource_if_missing('EthernetNetwork2')
  end

  it 'does nothing when EthernetNetwork2 exists' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to_not receive(:create)
    expect(real_chef_run).to create_oneview_resource_if_missing('EthernetNetwork2')
  end
end
