require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::switch_patch' do
  include_context 'chef context'
  let(:resource_name) { 'switch' }
  let(:api) { OneviewSDK::API300::C7000 }

  it 'performs patch operation' do
    expect_any_instance_of(api::Switch).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(api::Switch).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_switch('Switch1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(api::Switch).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /ResourceNotFound: Patch failed to apply since oneview_switch 'Switch1' does not exist/)
  end
end
