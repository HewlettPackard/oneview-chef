require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_interconnect_set_power_state' do
  let(:resource_name) { 'sas_interconnect' }
  let(:klass) { OneviewSDK::API300::Synergy::SASInterconnect }
  include_context 'chef context'

  it 'sets the SASInterconnect power state to a valid value' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:patch).with('replace', '/powerState', anything)
    expect(real_chef_run).to set_oneview_sas_interconnect_power_state('SASInterconnect1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end

describe 'oneview_test_api300_synergy::sas_interconnect_set_power_state_invalid' do
  let(:resource_name) { 'sas_interconnect' }
  let(:klass) { OneviewSDK::API300::Synergy::SASInterconnect }
  include_context 'chef context'

  it 'fails if power_state property is not set' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect { real_chef_run }.to raise_error(RuntimeError, /Unspecified property: 'power_state'/)
  end
end
