require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_extract_backup' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  let(:fake_artifact_bundle_backup) { base_sdk::ArtifactBundle.new(i3s_client300, downloadURI: 'fake_uri') }

  it 'extracts backup when backup and deployment group exist' do
    expect(base_sdk::ArtifactBundle).to receive(:find_by).and_return([fake_artifact_bundle_backup])
    expect_any_instance_of(base_sdk::DeploymentGroup).to receive(:retrieve!).and_return(true)
    expect(base_sdk::ArtifactBundle).to receive(:extract_backup).and_return(true)
    expect(real_chef_run).to extract_backup_image_streamer_artifact_bundle('BKP01')
  end

  it 'raises an error when deployment group does not exist' do
    expect(base_sdk::ArtifactBundle).to receive(:find_by).and_return([fake_artifact_bundle_backup])
    expect_any_instance_of(base_sdk::DeploymentGroup).to receive(:retrieve!).and_return(false)
    expect(base_sdk::ArtifactBundle).not_to receive(:extract_backup)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /DeploymentGroup with data '{:name=>"BKP01"}'/)
  end

  it 'raises an error when backup does not exist' do
    expect(base_sdk::ArtifactBundle).to receive(:find_by).and_return([])
    expect(base_sdk::ArtifactBundle).not_to receive(:extract_backup)
    expect { real_chef_run }.to raise_error(RuntimeError, /There are no backups present in the appliance. Cannot run extract_backup action./)
  end
end
