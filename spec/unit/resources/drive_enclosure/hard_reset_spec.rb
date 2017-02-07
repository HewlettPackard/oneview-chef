require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::drive_enclosure_hard_reset' do
  let(:resource_name) { 'drive_enclosure' }
  let(:klass) { OneviewSDK::API300::Synergy::DriveEnclosure }
  include_context 'chef context'

  it 'hard resets the drive enclosure' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:patch).with('replace', '/hardResetState', 'Reset')
    expect(real_chef_run).to hard_reset_oneview_drive_enclosure('DriveEnclosure1')
  end
end
