require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_create_if_missing' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  context 'given valid #golden_images, #build_plans, #deployment_plans and #plan_scripts' do
    before(:each) do
      allow_any_instance_of(base_sdk::BuildPlan).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(base_sdk::BuildPlan).to receive(:[]).with('uri').and_return('/rest/fake-build-plan')
      allow_any_instance_of(base_sdk::DeploymentPlan).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(base_sdk::DeploymentPlan).to receive(:[]).with('uri').and_return('/rest/fake-deployment-plan')
      allow_any_instance_of(base_sdk::GoldenImage).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(base_sdk::GoldenImage).to receive(:[]).with('uri').and_return('/rest/fake-golden-image')
      allow_any_instance_of(base_sdk::PlanScript).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(base_sdk::PlanScript).to receive(:[]).with('uri').and_return('/rest/fake-plan-script')
    end

    it 'creates it when it does not exist' do
      expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(false)
      expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:create).and_return(true)
      expect(real_chef_run).to create_image_streamer_artifact_bundle_if_missing('ArtifactBundle1')
    end

    it 'does nothing when it exists' do
      expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(true)
      expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(true)
      expect_any_instance_of(base_sdk::ArtifactBundle).to_not receive(:create)
      expect(real_chef_run).to create_image_streamer_artifact_bundle_if_missing('ArtifactBundle1')
    end
  end

  it 'Should raise an error when a resource passed in does not exist' do
    allow_any_instance_of(base_sdk::BuildPlan).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /BuildPlan with data '{:name=>"BP"}'/)
  end
end
