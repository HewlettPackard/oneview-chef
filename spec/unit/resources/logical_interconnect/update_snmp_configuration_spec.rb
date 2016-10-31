require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_update_snmp_configuration' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  # Mocks the update_handler
  before(:each) do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:like?).and_return(false)
  end

  it 'updates SNMP configuration' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:update_snmp_configuration).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_snmp_configuration('LogicalInterconnect-update_snmp_configuration')
  end
end
