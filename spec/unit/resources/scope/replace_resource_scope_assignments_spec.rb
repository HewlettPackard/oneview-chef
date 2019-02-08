require_relative './../../../spec_helper'

describe 'oneview_test_api600_synergy::scope_replace_resource_scopes_assignments' do
  let(:klass) { OneviewSDK::API600::Synergy::Scope }
  let(:en_klass) { OneviewSDK::API600::Synergy::Enclosure }
  let(:provider) { OneviewCookbook::API600::Synergy::ScopeProvider }
  let(:resource_name) { 'scope' }
  include_context 'chef context'
  include_context 'shared context'

  it 'Replaces a resource assigned scopes with the list of scopes provided' do
    fake_en = OneviewSDK::Enclosure.new(@client, name: '0000A66101')
    allow_any_instance_of(provider).to receive(:load_resource).with(:Enclosure, '0000A66101')
                                                              .and_return(fake_en)
    fake_scope = klass.new(@client, name: 'Scope2')
    allow_any_instance_of(provider).to receive(:load_resource).with(:Scope, 'Scope2')
                                                              .and_return(fake_scope)
    expect(klass).to receive(:replace_resource_assigned_scopes).and_return(true)
    expect(real_chef_run).to replace_oneview_scope_resource_scopes_assignments('Scope-replace_resource_scopes_assignments')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(en_klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /0000A66101/)
  end

  it 'fails if one of the scopes listed does not exist' do
    expect_any_instance_of(en_klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /Scope2/)
  end
end
