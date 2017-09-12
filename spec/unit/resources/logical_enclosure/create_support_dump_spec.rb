require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_create_support_dump' do
  let(:resource_name) { 'logical_enclosure' }
  include_context 'chef context'

  it 'generates a support dump' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:support_dump).with(errorCode: 'MyDump')
    expect(real_chef_run).to create_oneview_logical_enclosure_support_dump('LogicalEnclosure1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
