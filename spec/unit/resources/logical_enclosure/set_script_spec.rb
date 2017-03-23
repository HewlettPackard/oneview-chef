require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_set_script' do
  let(:resource_name) { 'logical_enclosure' }
  include_context 'chef context'

  it 'does nothing when the script is already up to date' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:get_script).and_return('script commands')
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to_not receive(:set_script).with('script commands')
    expect(real_chef_run).to set_oneview_logical_enclosure_script('LogicalEnclosure1')
  end

  it 'updates the script if it differs from the definition' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:get_script).and_return('')
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:set_script).with('script commands')
    expect(real_chef_run).to set_oneview_logical_enclosure_script('LogicalEnclosure1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
