require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::drive_enclosure_set_uid_light' do
  let(:resource_name) { 'drive_enclosure' }
  let(:klass) { OneviewSDK::API300::Synergy::DriveEnclosure }
  include_context 'chef context'

  it 'sets the DriveEnclosure UID light to a valid value' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:patch).with('replace', '/uidState', anything)
    expect(real_chef_run).to set_oneview_drive_enclosure_uid_light('DriveEnclosure1')
  end
end

describe 'oneview_test_api300_synergy::drive_enclosure_set_uid_light_invalid' do
  let(:resource_name) { 'drive_enclosure' }
  let(:klass) { OneviewSDK::API300::Synergy::DriveEnclosure }
  include_context 'chef context'

  it 'fails if uid_light_state property is not set' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect { real_chef_run }.to raise_error(RuntimeError, /Unspecified property: 'uid_light_state'/)
  end
end
