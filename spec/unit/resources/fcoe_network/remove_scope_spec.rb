require_relative './../../../spec_helper'

describe 'oneview_test_api300_c7000::fcoe_network_remove_scope' do
  let(:resource_name) { 'fcoe_network' }
  include_context 'chef context'

  let(:scope) { OneviewSDK::API300::C7000::Scope.new(client, name: 'Scope1', uri: '/rest/fake/1') }

  before do
    allow(OneviewSDK::API300::C7000::Scope).to receive(:new).and_return(scope)
    allow(scope).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).to receive(:retrieve!)
    allow_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).to receive(:[]).and_call_original
  end

  it 'adds scope when is not removed' do
    allow_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1'])
    expect_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).to receive(:remove_scope).with(scope)
    expect(real_chef_run).to remove_oneview_fcoe_network_scope('FCoENetwork1')
  end

  it 'does nothing when scope is already removed' do
    allow_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).to receive(:[]).with('scopeUris').and_return(['/rest/fake/2'])
    expect_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).not_to receive(:remove_scope)
    expect(real_chef_run).to remove_oneview_fcoe_network_scope('FCoENetwork1')
  end
end
