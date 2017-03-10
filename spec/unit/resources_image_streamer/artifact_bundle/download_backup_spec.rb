require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_download_backup' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  let(:fake_artifact_bundle_backup) { base_sdk::ArtifactBundle.new(i3s_client300, downloadUri: 'fake_uri') }

  it 'downloads resource when it exists and it has not been downloaded yet' do
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/BKP01.zip').and_return(false)
    expect(base_sdk::ArtifactBundle).to receive(:find_by).and_return([fake_artifact_bundle_backup])
    expect(base_sdk::ArtifactBundle).to receive(:download_backup).and_return(true)
    expect(real_chef_run).to download_backup_image_streamer_artifact_bundle('BKP01')
  end

  it 'not downloads when file to be downloaded already exists' do
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/BKP01.zip').and_return(true)
    expect(base_sdk::ArtifactBundle).not_to receive(:download_backup)
    expect(real_chef_run).to download_backup_image_streamer_artifact_bundle('BKP01')
  end

  it 'not download when resource does not exist' do
    allow(File).to receive(:file?).and_call_original
    allow(File).to receive(:file?).with('/tmp/BKP01.zip').and_return(false)
    expect(base_sdk::ArtifactBundle).to receive(:find_by).and_return([])
    expect { real_chef_run }.to raise_error(RuntimeError, /There are no backups present in the appliance. Cannot run download_backup action./)
  end
end
