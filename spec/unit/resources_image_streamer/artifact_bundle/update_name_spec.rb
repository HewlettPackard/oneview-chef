require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_update_name' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'updates it when it exists but is not alike' do
    allow_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:update_name).and_return(true)
    expect(real_chef_run).to update_image_streamer_artifact_bundle_name('ArtifactBundle1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(base_sdk::ArtifactBundle).to receive(:[]).with('name').and_return('ArtifactBundle2')
    expect_any_instance_of(base_sdk::ArtifactBundle).to_not receive(:update_name)
    expect(real_chef_run).to update_image_streamer_artifact_bundle_name('ArtifactBundle1')
  end

  it 'raises an error when a resource passed in does not exist' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end

  it 'raises an error when the new name is already in use' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(true)
    expect { real_chef_run }.to raise_error(RuntimeError, /ArtifactBundle name 'ArtifactBundle2' is already in use./)
  end
end
