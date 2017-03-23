require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_interconnect_reset' do
  let(:resource_name) { 'sas_interconnect' }
  let(:klass) { OneviewSDK::API300::Synergy::SASInterconnect }
  include_context 'chef context'

  it 'resets the SAS Interconnect' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:patch).with('replace', '/softResetState', 'Reset')
    expect(real_chef_run).to reset_oneview_sas_interconnect('SASInterconnect1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end

describe 'oneview_test_api300_synergy::sas_interconnect_hard_reset' do
  let(:resource_name) { 'sas_interconnect' }
  let(:klass) { OneviewSDK::API300::Synergy::SASInterconnect }
  include_context 'chef context'

  it 'hard resets the SAS Interconnect' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:patch).with('replace', '/hardResetState', 'Reset')
    expect(real_chef_run).to hard_reset_oneview_sas_interconnect('SASInterconnect1')
  end
end
