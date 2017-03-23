require_relative './../../../spec_helper'

describe 'oneview_test::connection_template_update' do
  let(:resource_name) { 'connection_template' }
  include_context 'chef context'
  include_context 'shared context'

  it 'updates it searching by the Ethernet Network' do
    fake_ethernet = OneviewSDK::EthernetNetwork.new(@client, connectionTemplateUri: 'fake/connection-template')
    fake_fc = OneviewSDK::FCNetwork.new(@client, connectionTemplateUri: 'fake/connection-template')
    fake_fcoe = OneviewSDK::FCoENetwork.new(@client, connectionTemplateUri: 'fake/connection-template')
    fake_net = OneviewSDK::NetworkSet.new(@client, connectionTemplateUri: 'fake/connection-template')
    allow(OneviewSDK::EthernetNetwork).to receive(:find_by).and_return([fake_ethernet])
    allow(OneviewSDK::FCNetwork).to receive(:find_by).and_return([fake_fc])
    allow(OneviewSDK::FCoENetwork).to receive(:find_by).and_return([fake_fcoe])
    allow(OneviewSDK::NetworkSet).to receive(:find_by).and_return([fake_net])
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(false)
    update_count = 0
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:update) { update_count += 1 }
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate1')
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate2')
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate3')
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate4')
    expect(update_count).to eq(4)
  end

  it 'leave it as is since it is up to date' do
    fake_ethernet = OneviewSDK::EthernetNetwork.new(@client, connectionTemplateUri: 'fake/connection-template')
    fake_fc = OneviewSDK::FCNetwork.new(@client, connectionTemplateUri: 'fake/connection-template')
    fake_fcoe = OneviewSDK::FCoENetwork.new(@client, connectionTemplateUri: 'fake/connection-template')
    fake_net = OneviewSDK::NetworkSet.new(@client, connectionTemplateUri: 'fake/connection-template')
    allow(OneviewSDK::EthernetNetwork).to receive(:find_by).and_return([fake_ethernet])
    allow(OneviewSDK::FCNetwork).to receive(:find_by).and_return([fake_fc])
    allow(OneviewSDK::FCoENetwork).to receive(:find_by).and_return([fake_fcoe])
    allow(OneviewSDK::NetworkSet).to receive(:find_by).and_return([fake_net])
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::ConnectionTemplate).to_not receive(:update)
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate1')
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate2')
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate3')
    expect(real_chef_run).to update_oneview_connection_template('ConnectionTemplate4')
  end
end
