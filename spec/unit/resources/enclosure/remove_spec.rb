require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_remove' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  it 'removes it when it exists' do
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_enclosure('Enclosure2')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::Enclosure).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_enclosure('Enclosure2')
  end
end
