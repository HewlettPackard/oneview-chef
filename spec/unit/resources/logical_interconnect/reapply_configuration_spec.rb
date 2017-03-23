require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_reapply_configuration' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  it 'reapplies the configuration in all teh associated interconnects' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:configuration).and_return(true)
    expect(real_chef_run).to reapply_oneview_logical_interconnect_configuration('LogicalInterconnect-reapply_configuration')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
