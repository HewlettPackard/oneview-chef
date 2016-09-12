require_relative './../../../spec_helper'

describe 'oneview_test::interconnect_reset_port_protection' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  it 'resets port protection for the Interconect' do
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Interconnect).to receive(:reset_port_protection)
    expect(real_chef_run).to reset_oneview_interconnect_port_protection('Interconnect4')
  end
end
