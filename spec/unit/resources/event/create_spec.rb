require_relative './../../../spec_helper'

describe 'oneview_test::event_create' do
  let(:resource_name) { 'event' }
  include_context 'chef context'

  it 'creates it' do
    expect_any_instance_of(OneviewSDK::Event).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_event('Event1')
  end
end
