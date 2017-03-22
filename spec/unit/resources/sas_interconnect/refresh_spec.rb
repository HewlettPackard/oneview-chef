require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_interconnect_refresh' do
  let(:resource_name) { 'sas_interconnect' }
  let(:klass) { OneviewSDK::API300::Synergy::SASInterconnect }
  include_context 'chef context'

  it 'refresh SAS interconnect already triggered' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('refreshState').and_return('RefreshPending')
    allow_any_instance_of(klass).to receive(:[]).with('name').and_return('SASInterconnect1')
    expect_any_instance_of(klass).to_not receive(:set_refresh_state)
    expect(real_chef_run).to refresh_oneview_sas_interconnect('SASInterconnect1')
  end

  it 'refresh SAS interconnect' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('refreshState').and_return('NotRefreshing')
    allow_any_instance_of(klass).to receive(:[]).with('name').and_return('SASInterconnect1')
    expect_any_instance_of(klass).to receive(:set_refresh_state).and_return(true)
    expect(real_chef_run).to refresh_oneview_sas_interconnect('SASInterconnect1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
