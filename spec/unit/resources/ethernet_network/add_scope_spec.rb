require_relative './../../../spec_helper'

describe 'oneview_test_api300_c7000::ethernet_network_add_scope' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  let(:scope) { OneviewSDK::API300::C7000::Scope.new(client, name: 'Scope1', uri: '/rest/fake') }

  before do
    allow(OneviewSDK::API300::C7000::Scope).to receive(:find_by).and_return([scope])
    allow_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:[]).and_call_original
  end

  it 'adds scope when is not added' do
    allow_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:[]).with('scopeUris').and_return([])
    expect_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:add_scope).with(scope)
    expect(real_chef_run).to add_oneview_ethernet_network_scope('EthernetNetwork1')
  end

  it 'does nothing when scope is already added' do
    allow_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:[]).with('scopeUris').and_return(['/rest/fake'])
    expect_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).not_to receive(:add_scope).with(scope)
    expect(real_chef_run).to add_oneview_ethernet_network_scope('EthernetNetwork1')
  end
end
