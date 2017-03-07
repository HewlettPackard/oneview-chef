require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::golden_image_create_if_missing' do
  let(:complete_resource_name) { 'image_streamer_golden_image' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  before(:each) do
    # Mocks the load_resources
    fake_os_volume = Object.new
    fake_build_plan = Object.new
    allow(base_sdk::OSVolume).to receive(:new).and_return(fake_os_volume)
    allow(base_sdk::BuildPlan).to receive(:new).and_return(fake_build_plan)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:set_os_volume).with(fake_os_volume).and_return(true)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:set_build_plan).with(fake_build_plan).and_return(true)
  end

  it 'creates it when it does not exist' do
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:create).and_return(true)
    expect(real_chef_run).to create_image_streamer_golden_image_if_missing('GoldenImage1')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:exists?).and_return(true)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::GoldenImage).to_not receive(:create)
    expect(real_chef_run).to create_image_streamer_golden_image_if_missing('GoldenImage1')
  end
end
