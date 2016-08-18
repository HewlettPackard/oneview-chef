require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_reconfigure' do
  let(:resource_name) { 'logical_enclosure' }
  include_context 'chef context'

  it 'reapply configuration for logical enclosure' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:reconfigure).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_logical_enclosure('LogicalEnclosure1')
  end
end
