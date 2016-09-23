require_relative './../../../spec_helper'

describe 'oneview_test::rack_add_if_missing' do
  let(:resource_name) { 'rack' }
  include_context 'chef context'

  it 'rack does not exist' do
    allow_any_instance_of(OneviewSDK::Rack).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_rack_if_missing('Rack1')
  end

  it 'rack already exists' do
    allow_any_instance_of(OneviewSDK::Rack).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Rack).to_not receive(:add)
    expect(real_chef_run).to add_oneview_rack_if_missing('Rack1')
  end
end
