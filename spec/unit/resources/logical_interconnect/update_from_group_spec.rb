require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_update_from_group' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  it 'updates the logical interconnect from the logical interconnect group' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:compliance).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_from_group('LogicalInterconnect-update_from_group')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
