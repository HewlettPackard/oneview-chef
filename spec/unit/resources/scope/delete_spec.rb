require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::scope_delete' do
  let(:klass) { OneviewSDK::API300::Synergy::Scope }
  let(:resource_name) { 'scope' }
  include_context 'chef context'

  it 'deletes it when it exists' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_scope('Scope3')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(klass).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_scope('Scope3')
  end
end
