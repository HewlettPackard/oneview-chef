require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_update_from_template' do
  let(:resource_name) { 'server_profile' }
  include_context 'chef context'

  let(:klass) { OneviewSDK::ServerProfile }
  let(:profile) { klass.new(client, templateCompliance: 'Compliant') }
  let(:inc_profile) { profile.set_all(templateCompliance: 'NonCompliant') }

  before :each do
    allow_any_instance_of(klass).to receive(:get_compliance_preview)
      .and_return(isOnlineUpdate: true, automaticUpdates: %i[stuff things], manualUpdates: [])
    allow(Chef::Log).to receive(:info)
  end

  it 'does nothing when it is consistent' do
    expect(klass).to receive(:find_by).and_return([profile])
    expect_any_instance_of(klass).to_not receive(:update_from_template)
    expect(real_chef_run).to update_oneview_server_profile_from_template('ServerProfile4')
    expect(Chef::Log).to have_received(:info).with(/up to date/)
  end

  it 'updates it when it is not consistent' do
    expect(klass).to receive(:find_by).and_return([inc_profile])
    expect_any_instance_of(klass).to receive(:update_from_template).and_return(true)
    expect(real_chef_run).to update_oneview_server_profile_from_template('ServerProfile4')
    expect(Chef::Log).to have_received(:info).with(/Updating.*from template.*Preview:[\s\S]*stuff/)
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
