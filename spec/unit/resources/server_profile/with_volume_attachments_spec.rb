require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_add_volume_attachments' do
  let(:resource_name) { 'server_profile' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:target_class) { base_sdk::ServerProfile }
  let(:target_provider_class) { OneviewCookbook::API200::ServerProfileProvider }
  let(:target_match_method) { [:create_oneview_server_profile, 'ServerProfile1'] }
  it_behaves_like 'action :create #add_volume_attachments'
end

describe 'oneview_test::server_profile_create_volume_attachments' do
  let(:resource_name) { 'server_profile' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:target_class) { base_sdk::ServerProfile }
  let(:target_provider_class) { OneviewCookbook::API200::ServerProfileProvider }
  let(:target_match_method) { [:create_oneview_server_profile, 'ServerProfile1'] }
  it_behaves_like 'action :create #create_volume_attachments'
end

describe 'oneview_test::server_profile_create_wrong_volume_attachments' do
  let(:resource_name) { 'server_profile' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::ServerProfile }
  let(:target_match_method) { [:create_oneview_server_profile, 'ServerProfile1'] }
  it_behaves_like 'action :create #create_volume_attachments with wrong data'
end
