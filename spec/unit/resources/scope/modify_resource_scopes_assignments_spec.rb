require_relative './../../../spec_helper'

describe 'oneview_test_api600_synergy::scope_modify_resource_scopes_assignments' do
  let(:klass) { OneviewSDK::API600::Synergy::Scope }
  let(:provider) { OneviewCookbook::API600::Synergy::ScopeProvider }
  let(:sh_klass) { OneviewSDK::API600::Synergy::ServerHardware }
  let(:resource_name) { 'scope' }
  include_context 'chef context'
  include_context 'shared context'

  it 'Adds scopes that needs to be associated with the resource and removes scopes' do
    fake_scope = klass.new(@client, name: 'scope2')
    allow_any_instance_of(provider).to receive(:load_resource).with(:Scope, 'scope2')
                                                              .and_return(fake_scope)
    fake_scope = klass.new(@client, name: 'scope1')
    allow_any_instance_of(provider).to receive(:load_resource).with(:Scope, 'scope1')
                                                              .and_return(fake_scope)
    fake_server_hardware = sh_klass.new(@client, name: 'ServerHardware')
    allow_any_instance_of(provider).to receive(:load_resource).with(:ServerHardware, '0000A66101, bay 3')
                                                              .and_return(fake_server_hardware)
    expect(klass).to receive(:resource_patch).and_return(true)
    expect(real_chef_run).to modify_oneview_scope_resource_scopes_assignments('Scope-modify_resource_scopes_assignments')
  end

  it 'fails if the resource is not found' do
    allow(klass).to receive(:find_by).at_most(2).times
                                     .and_return([klass.new(client, uri: '/rest/fake')])
    expect_any_instance_of(sh_klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /0000A66101, bay 3/)
  end

  it 'fails if one of the scopes listed does not exist' do
    allow(sh_klass).to receive(:find_by).and_return([sh_klass.new(client, uri: '/rest/fake')])
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /not found/)
  end
end
