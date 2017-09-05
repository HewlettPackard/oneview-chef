require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::scope_create' do
  let(:klass) { OneviewSDK::API300::Synergy::Scope }
  let(:resource_name) { 'scope' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_scope('Scope1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(false)
    expect_any_instance_of(klass).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_scope('Scope1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(true)
    expect_any_instance_of(klass).to_not receive(:update)
    expect_any_instance_of(klass).to_not receive(:create)
    expect(real_chef_run).to create_oneview_scope('Scope1')
  end
end
