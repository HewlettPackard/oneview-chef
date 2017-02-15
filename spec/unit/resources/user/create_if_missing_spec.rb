require_relative './../../../spec_helper'

klass = OneviewSDK::API200::User
describe 'oneview_test::user_create_if_missing' do
  let(:resource_name) { 'user' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_user_if_missing('User2')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to_not receive(:create)
    expect(real_chef_run).to create_oneview_user_if_missing('User2')
  end
end
