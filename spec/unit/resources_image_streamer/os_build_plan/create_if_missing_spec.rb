require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::os_build_plan_create_if_missing' do
  let(:complete_resource_name) { 'image_streamer_os_build_plan' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'creates it when it does not exist' do
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:create).and_return(true)
    expect(real_chef_run).to create_image_streamer_os_build_plan_if_missing('OSBuildPlan1')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:exists?).and_return(true)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::BuildPlan).to_not receive(:create)
    expect(real_chef_run).to create_image_streamer_os_build_plan_if_missing('OSBuildPlan1')
  end
end
