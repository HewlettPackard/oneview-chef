require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::drive_enclosure_refresh' do
  let(:resource_name) { 'drive_enclosure' }
  let(:klass) { OneviewSDK::API300::Synergy::DriveEnclosure }
  include_context 'chef context'

  it 'refresh drive enclosure already triggered' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('refreshState').and_return('RefreshPending')
    allow_any_instance_of(klass).to receive(:[]).with('name').and_return('DriveEnclosure1')
    expect_any_instance_of(klass).to_not receive(:set_refresh_state)
    expect(real_chef_run).to refresh_oneview_drive_enclosure('DriveEnclosure1')
  end

  it 'refresh drive enclosure' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('refreshState').and_return('NotRefreshing')
    allow_any_instance_of(klass).to receive(:[]).with('name').and_return('DriveEnclosure1')
    expect_any_instance_of(klass).to receive(:set_refresh_state).and_return(true)
    expect(real_chef_run).to refresh_oneview_drive_enclosure('DriveEnclosure1')
  end
end
