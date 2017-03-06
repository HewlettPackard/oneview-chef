require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::golden_image_download_details_archive' do
  let(:complete_resource_name) { 'image_streamer_golden_image' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'downloads the details if it exists' do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('details.txt').and_return(false)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:download_details_archive).with('details.txt').and_return(true)
    expect(real_chef_run).to download_image_streamer_golden_image_details_archive('GoldenImage1')
  end
end
