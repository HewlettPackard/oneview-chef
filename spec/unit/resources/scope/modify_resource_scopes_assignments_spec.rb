require_relative './../../../spec_helper'

describe 'oneview_test_API600_synergy::scope_modify_resource_scopes_assignments' do
  let(:klass) { OneviewSDK::API600::Synergy::Scope }
  let(:klass1) { OneviewSDK::API600::Synergy::Scope }
  let(:sh_klass) { OneviewSDK::API600::Synergy::ServerHardware }
  let(:resource_name) { 'scope' }
  include_context 'chef context'

  it 'Adds scopes that needs to be associated with the resource and removes scopes' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass1).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(sh_klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('name').and_return(['fake'])
    allow_any_instance_of(klass).to receive(:[]).with('uri').and_return(['/rest/fake-scope-uri'])
    allow_any_instance_of(klass1).to receive(:[]).with('name').and_return(['fake'])
    allow_any_instance_of(klass1).to receive(:[]).with('uri').and_return(['/rest/fake-scope-uri'])
    expect_any_instance_of(sh_klass).to receive(:[]).with('scopeUris').and_return(['/rest/fake-scope-uri'])
    allow(klass).to receive(:resource_patch).and_return(true)
    expect(real_chef_run).to modify_oneview_scope_resource_scopes_assignments('Scope-modify_resource_scopes_assignments')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(sh_klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /0000A66101, bay 3/)
  end

  it 'fails if one of the scopes listed does not exist' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(klass1).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
