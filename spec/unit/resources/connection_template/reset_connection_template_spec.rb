require_relative './../../../spec_helper'

describe 'oneview_test::connection_template_reset' do
  let(:resource_name) { 'connection_template' }
  include_context 'chef context'
  include_context 'shared context'

  it 'updates it searching by the Ethernet Network' do
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::ConnectionTemplate).to receive(:get_default).and_return({})
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:update).and_return(true)
    expect(real_chef_run).to reset_oneview_connection_template('ConnectionTemplate2')
  end

  it 'leave it as is since it is up to date' do
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::ConnectionTemplate).to receive(:get_default).and_return({})
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::ConnectionTemplate).to_not receive(:update)
    expect(real_chef_run).to reset_oneview_connection_template('ConnectionTemplate2')
  end
end
