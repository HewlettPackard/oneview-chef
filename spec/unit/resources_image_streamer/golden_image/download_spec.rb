require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::golden_image_download' do
  let(:complete_resource_name) { 'image_streamer_golden_image' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'downloads it if it exists' do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('golden_image.zip').and_return(false)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:download).with('golden_image.zip', 900).and_return(true)
    expect(real_chef_run).to download_image_streamer_golden_image('GoldenImage1')
  end
end
