require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_reconfigure' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  it 'refresh enclosure with default options' do
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:configuration).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_enclosure('Enclosure1')
  end
end
