require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_update_from_group' do
  let(:resource_name) { 'logical_enclosure' }
  include_context 'chef context'

  before :each do
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).and_call_original
  end

  it 'fails when LogicalEnclosure1 does not exist' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end

  it 'updates LogicalEnclosure1 when it is inconsistent' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('state').and_return('Inconsistent')
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:update_from_group).and_return(true)
    expect(real_chef_run).to update_oneview_logical_enclosure_from_group('LogicalEnclosure1')
  end

  it 'does nothing when LogicalEnclosure1 is consistent' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('state').and_return('Consistent')
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to_not receive(:update_from_group)
    expect(real_chef_run).to update_oneview_logical_enclosure_from_group('LogicalEnclosure1')
  end
end
