require_relative './../../../spec_helper'

describe 'oneview_test::interconnect_set_power_state' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  it 'sets the Interconnect power state to a valid value' do
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Interconnect).to receive(:patch).with('replace', '/powerState', anything)
    expect(real_chef_run).to set_oneview_interconnect_power_state('Interconnect2')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end

describe 'oneview_test::interconnect_set_power_state_invalid' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  it 'fails if power_state property is not set' do
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    expect { real_chef_run }.to raise_error(RuntimeError, /Unspecified property: 'power_state'/)
  end
end
