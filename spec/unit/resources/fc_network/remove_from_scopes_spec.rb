require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::fc_network_remove_from_scopes' do
  let(:resource_name) { 'fc_network' }
  include_context 'chef context'

  let(:scope1) { OneviewSDK::API300::Synergy::Scope.new(client, name: 'Scope1', uri: '/rest/fake/1') }
  let(:scope2) { OneviewSDK::API300::Synergy::Scope.new(client, name: 'Scope2', uri: '/rest/fake/2') }

  before do
    allow(OneviewSDK::API300::Synergy::Scope).to receive(:new).and_return(scope1, scope2)
    allow(scope1).to receive(:retrieve!).and_return(true)
    allow(scope2).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:[]).and_call_original
  end

  it 'removes all scopes when are not removed' do
    allow_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1', '/rest/fake/2'])
    expect_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:remove_scope).with(scope1)
    expect_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:remove_scope).with(scope2)
    expect(real_chef_run).to remove_oneview_fc_network_from_scopes('FCNetwork1')
  end

  it 'removes only the one scope that is not removed' do
    allow_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1'])
    expect_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:remove_scope).with(scope1)
    expect_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).not_to receive(:remove_scope).with(scope2)
    expect(real_chef_run).to remove_oneview_fc_network_from_scopes('FCNetwork1')
  end

  it 'does nothing when scope is already removed' do
    allow_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:[]).with('scopeUris').and_return(['/rest/fake/other-scope'])
    expect_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).not_to receive(:remove_scope)
    expect(real_chef_run).to remove_oneview_fc_network_from_scopes('FCNetwork1')
  end
end
