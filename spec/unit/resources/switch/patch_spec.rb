require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::switch_patch' do
  include_context 'chef context'
  let(:resource_name) { 'switch' }
  let(:api) { OneviewSDK::API300::C7000 }
  let(:patch_body) { { 'body' => [op: 'test', path: 'test/', value: 'TestMessage'] } }

  it 'performs patch operation' do
    allow_any_instance_of(api::Switch).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(api::Switch).to receive(:[]).and_call_original
    allow_any_instance_of(api::Switch).to receive(:[]).with('uri').and_return('rest/fake')
    allow_any_instance_of(api::Switch).to receive(:client).and_return(client300)

    expect_any_instance_of(OneviewSDK::Client).to receive(:rest_patch).with('rest/fake', patch_body, 300).and_return('patch' => 'ok')
    expect_any_instance_of(OneviewSDK::Client).to receive(:response_handler).with('patch' => 'ok').and_return(true)

    expect(real_chef_run).to patch_oneview_switch('Switch1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(api::Switch).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
