require_relative './../../../spec_helper'

describe 'oneview_test_api2000_c7000::logical_interconnect_bulk_inconsistency_validate' do
  before(:each) do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:like?).and_return(false)
  end

  it 'gets the inconsistency report for bulk update' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:bulk_inconsistency_validate).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_settings('LogicalInterconnect-bulk_inconsistency_validate')
  end
end
