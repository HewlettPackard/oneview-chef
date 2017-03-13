require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_upload' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'Uploads resource when backup file exists and resource does not exist in appliance' do
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/AB01.zip').and_return(true)
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(false)
    expect(base_sdk::ArtifactBundle).to receive(:create_from_file).and_return(true)
    expect(real_chef_run).to upload_image_streamer_artifact_bundle('ArtifactBundle1')
  end

  it 'not uploads when resource already exists' do
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/AB01.zip').and_return(true)
    expect_any_instance_of(base_sdk::ArtifactBundle).to receive(:exists?).and_return(true)
    expect(base_sdk::ArtifactBundle).not_to receive(:create_from_file)
    expect(real_chef_run).to upload_image_streamer_artifact_bundle('ArtifactBundle1')
  end

  it 'raises an error when file to be uploaded does not exist' do
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/AB01.zip').and_return(false)
    expect(base_sdk::ArtifactBundle).not_to receive(:create_from_file)
    expect { real_chef_run }.to raise_error(RuntimeError, /file does not exist./)
  end
end
