require_relative './../../../spec_helper'

describe 'oneview_test_api2000_c7000::logical_interconnect_validate_bulk_inconsistency' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::API2000::C7000::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
