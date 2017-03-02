require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::deployment_plan_create_if_missing' do
  let(:complete_resource_name) { 'image_streamer_deployment_plan' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  context 'given a valid #golden_image & #build_plan' do
    before(:each) do
      expect_any_instance_of(base_sdk::GoldenImage).to receive(:retrieve!).and_return(true)
      expect_any_instance_of(base_sdk::GoldenImage).to receive(:[]).with(:uri).and_return('/rest/fake-golden-image')
      expect_any_instance_of(base_sdk::BuildPlan).to receive(:retrieve!).and_return(true)
      expect_any_instance_of(base_sdk::BuildPlan).to receive(:[]).with(:uri).and_return('/rest/fake-build-plan')
    end

    it 'creates it when it does not exist' do
      expect_any_instance_of(base_sdk::DeploymentPlan).to receive(:exists?).and_return(false)
      expect_any_instance_of(base_sdk::DeploymentPlan).to receive(:create).and_return(true)
      expect(real_chef_run).to create_image_streamer_deployment_plan_if_missing('DeploymentPlan1')
    end

    it 'does nothing when it exists' do
      expect_any_instance_of(base_sdk::DeploymentPlan).to receive(:exists?).and_return(true)
      expect_any_instance_of(base_sdk::DeploymentPlan).to receive(:retrieve!).and_return(true)
      expect_any_instance_of(base_sdk::DeploymentPlan).to_not receive(:create)
      expect(real_chef_run).to create_image_streamer_deployment_plan_if_missing('DeploymentPlan1')
    end
  end
end
