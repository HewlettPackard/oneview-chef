require_relative './../../../spec_helper'

klass = OneviewSDK::API200::User
describe 'oneview_test::user_delete' do
  let(:resource_name) { 'user' }
  include_context 'chef context'

  it 'deletes it when it exists' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_user('User3')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(klass).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_user('User3')
  end
end
