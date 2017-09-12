require_relative './../../../spec_helper'

describe 'oneview_test_api500_synergy::storage_pool_refresh' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API500::Synergy::StoragePool }
  let(:target_match_method) { [:refresh_oneview_storage_pool, 'StoragePool'] }
  it_behaves_like 'action :refresh'
end
