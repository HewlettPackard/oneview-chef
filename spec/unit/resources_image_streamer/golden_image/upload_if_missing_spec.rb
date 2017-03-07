require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::golden_image_upload_if_missing' do
  let(:complete_resource_name) { 'image_streamer_golden_image' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'uploads it if the file exists but the resource do not' do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('golden_image.zip').and_return(true)
    expect_any_instance_of(base_sdk::GoldenImage).to receive(:exists?).and_return(false)
    request_data = {
      'name' => 'GoldenImage1',
      'description' => 'UPLOAD',
      'type' => 'GoldenImage'
    }
    expect(base_sdk::GoldenImage).to receive(:add)
      .with(instance_of(OneviewSDK::ImageStreamer::Client), 'golden_image.zip', request_data, 1200).and_return(true)
    expect(real_chef_run).to upload_image_streamer_golden_image_if_missing('GoldenImage1')
  end
end
