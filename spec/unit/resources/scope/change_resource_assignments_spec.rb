require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::scope_change_resource_assignments' do
  let(:klass) { OneviewSDK::API300::Synergy::Scope }
  let(:en_klass) { OneviewSDK::API300::Synergy::Enclosure }
  let(:sh_klass) { OneviewSDK::API300::Synergy::ServerHardware }
  let(:resource_name) { 'scope' }
  include_context 'chef context'

  it 'Adds resources that do not exist and Removes resources that do exist when required' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(en_klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(sh_klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('name').and_return(['fake'])
    allow_any_instance_of(klass).to receive(:[]).with('uri').and_return(['/rest/fake-scope-uri'])
    expect_any_instance_of(en_klass).to receive(:[]).with('scopeUris').and_return([])
    expect_any_instance_of(sh_klass).to receive(:[]).with('scopeUris').and_return(['/rest/fake-scope-uri'])
    expect_any_instance_of(klass).to receive(:change_resource_assignments).and_return(true)
    expect(real_chef_run).to change_oneview_scope_resource_assignments('Scope-change_resource_assignments')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end

  it 'fails if one of the resources listed does not exist' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(en_klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /Encl1/)
  end
end
