require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_extract' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'extracts resource when it exists' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(true)
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:extract).and_return(true)
    expect(real_chef_run).to extract_image_streamer_artifact_bundle('ArtifactBundle1')
  end

  it 'does not extract when resource does not exist' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::ArtifactBundle).not_to receive(:extract)
    expect { real_chef_run }.to raise_error(RuntimeError, /ArtifactBundle1 does not exist in the appliance. Cannot run extract action./)
  end
end
