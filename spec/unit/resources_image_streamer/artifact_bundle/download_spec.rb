require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_download' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'downloads resource when it exists and it has not been downloaded yet' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(true)
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/AB01.zip').and_return(false)
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:download).with('/tmp/AB01.zip').and_return(true)
    expect(real_chef_run).to download_image_streamer_artifact_bundle('ArtifactBundle1')
  end

  it 'not downloads when file to be downloaded already exists' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(true)
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/AB01.zip').and_return(true)
    expect_any_instance_of(base_sdk::ArtifactBundle).to_not receive(:download)
    expect(real_chef_run).to download_image_streamer_artifact_bundle('ArtifactBundle1')
  end

  it 'not download when resource does not exist' do
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
