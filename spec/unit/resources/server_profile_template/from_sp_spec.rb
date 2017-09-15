require_relative './../../../spec_helper'

describe 'oneview_test_api500_synergy::server_profile_template_from_sp' do
  let(:resource_name) { 'server_profile_template' }
  let(:spt_klass) { OneviewSDK::API500::C7000::ServerProfileTemplate }
  let(:sp_klass) { OneviewSDK::API500::C7000::ServerProfile }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(sp_klass).to receive(:retrieve!).and_return(sp_klass.new(client))
    expect_any_instance_of(sp_klass).to receive(:get_profile_template).and_return(spt_klass.new(client))
    expect_any_instance_of(spt_klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(spt_klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_server_profile_template('ServerProfileTemplate1')
  end
end
