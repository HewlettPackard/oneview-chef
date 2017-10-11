require_relative './../../../spec_helper'

describe 'oneview_test_api500_synergy::storage_pool_refresh' do
  let(:resource_name) { 'storage_pool' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::StoragePool }
  let(:target_match_method) { [:refresh_oneview_storage_pool, 'StoragePool'] }
  it_behaves_like 'action :refresh #request_refresh' do
    before do
      allow_any_instance_of(base_sdk::StorageSystem).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewCookbook::API500::Synergy::StoragePoolProvider).to receive(:load_resource)
        .with(:StorageSystem, anything)
        .and_return(base_sdk::StorageSystem.new(client500, uri: '/sotrage-system/1'))
    end
  end
end
