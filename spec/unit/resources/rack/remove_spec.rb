require_relative './../../../spec_helper'

describe 'oneview_test::rack_remove' do
  let(:resource_name) { 'rack' }
  include_context 'chef context'

  it 'removes it when it exists' do
    allow_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_rack('Rack1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::Rack).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_rack('Rack1')
  end
end
