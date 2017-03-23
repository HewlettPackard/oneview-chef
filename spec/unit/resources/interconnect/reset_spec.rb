require_relative './../../../spec_helper'

describe 'oneview_test::interconnect_reset' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  it 'resets the Interconnect' do
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Interconnect).to receive(:patch).with('replace', '/deviceResetState', 'Reset')
    expect(real_chef_run).to reset_oneview_interconnect('Interconnect3')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
