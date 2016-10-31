require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_update_qos_configuration' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  # Mocks the update_handler
  before(:each) do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:like?).and_return(false)
  end

  it 'updates quality of service configurations' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:update_qos_configuration).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_qos_configuration('LogicalInterconnect-update_qos_configuration')
  end
end
