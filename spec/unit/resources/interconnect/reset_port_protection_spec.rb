require_relative './../../../spec_helper'

describe 'oneview_test::interconnect_reset_port_protection' do
  let(:resource_name) { 'interconnect' }
  let(:target_class) { OneviewSDK::API200::Interconnect }
  include_context 'chef context'

  it 'resets port protection for the Interconnect' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:reset_port_protection)
    expect(real_chef_run).to reset_oneview_interconnect_port_protection('Interconnect4')
  end
end
