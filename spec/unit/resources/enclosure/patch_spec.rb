require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_patch' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_enclosure('Enclosure1')
  end
end
