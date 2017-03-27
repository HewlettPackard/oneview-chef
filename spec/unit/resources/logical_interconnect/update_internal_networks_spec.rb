require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_update_internal_networks' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  it 'updates the internal networks' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:update_internal_networks).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_internal_networks('LogicalInterconnect-update_internal_networks')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
