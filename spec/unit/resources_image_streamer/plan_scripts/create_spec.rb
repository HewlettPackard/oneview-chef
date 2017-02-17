require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::plan_script_create' do
  let(:complete_resource_name) { 'image_streamer_plan_script' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'creates it when it does not exist' do
    expect_any_instance_of(base_sdk::PlanScript).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::PlanScript).to receive(:create).and_return(true)
    expect(real_chef_run).to create_image_streamer_plan_script('PlanScript1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(base_sdk::PlanScript).to receive(:exists?).and_return(true)
    expect_any_instance_of(base_sdk::PlanScript).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::PlanScript).to receive(:like?).and_return(false)
    expect_any_instance_of(base_sdk::PlanScript).to receive(:update).and_return(true)
    expect(real_chef_run).to create_image_streamer_plan_script('PlanScript1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(base_sdk::PlanScript).to receive(:exists?).and_return(true)
    expect_any_instance_of(base_sdk::PlanScript).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::PlanScript).to receive(:like?).and_return(true)
    expect_any_instance_of(base_sdk::PlanScript).to_not receive(:update)
    expect_any_instance_of(base_sdk::PlanScript).to_not receive(:create)
    expect(real_chef_run).to create_image_streamer_plan_script('PlanScript1')
  end
end
