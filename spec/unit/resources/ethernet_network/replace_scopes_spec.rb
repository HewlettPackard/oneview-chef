require_relative './../../../spec_helper'

describe 'oneview_test_api300_c7000::ethernet_network_replace_scopes' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  it 'replace scopes' do
    scope_1 = OneviewSDK::API300::C7000::Scope.new(client, name: 'Scope1', uri: '/rest/fake/1')
    scope_2 = OneviewSDK::API300::C7000::Scope.new(client, name: 'Scope2', uri: '/rest/fake/2')
    allow(OneviewSDK::API300::C7000::Scope).to receive(:find_by)
      .and_return([scope_1])
      .and_return([scope_2])
    allow_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:[]).and_call_original
    expect_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:replace_scopes).with([scope_1, scope_2])
    expect(real_chef_run).to replace_oneview_ethernet_network_scopes('EthernetNetwork1')
  end
end
