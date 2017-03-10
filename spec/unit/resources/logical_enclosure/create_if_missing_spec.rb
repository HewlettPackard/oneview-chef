require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_create_if_missing' do
  let(:resource_name) { 'logical_enclosure' }
  let(:klass) { OneviewSDK::LogicalEnclosure }
  include_context 'chef context'
  let(:provider) { OneviewCookbook::API200::LogicalEnclosureProvider }

  before :each do
    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource)
      .with(:EnclosureGroup, anything, 'uri').and_return('/rest/fake')
    allow_any_instance_of(provider).to receive(:load_resource)
      .with(:Enclosure, anything, 'uri').and_return('/rest/fake')
  end

  it 'creates it when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_logical_enclosure_if_missing('LogicalEnclosure1')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to_not receive(:create)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect(real_chef_run).to create_oneview_logical_enclosure_if_missing('LogicalEnclosure1')
  end
end
