require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::artifact_bundle_backup' do
  let(:complete_resource_name) { 'image_streamer_artifact_bundle' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'backups resource when it exists' do
    expect_any_instance_of(base_sdk::DeploymentGroup).to receive(:retrieve!).and_return(true)
    expect(base_sdk::ArtifactBundle).to receive(:create_backup).and_return(true)
    expect(real_chef_run).to backup_image_streamer_artifact_bundle('DeploymentGroup1')
  end

  it 'does not run backup when resource does not exist' do
    expect_any_instance_of(base_sdk::DeploymentGroup).to receive(:retrieve!).and_return(false)
    expect(base_sdk::ArtifactBundle).not_to receive(:create_backup)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /DeploymentGroup with data '{:name=>"DeploymentGroup1"}'/)
  end
end
