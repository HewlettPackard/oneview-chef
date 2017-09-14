require_relative './../../../spec_helper'

describe 'oneview_test::server_hardware_refresh' do
  let(:resource_name) { 'server_hardware' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::ServerHardware }
  let(:target_match_method) { [:refresh_oneview_server_hardware, 'ServerHardware1'] }
  it_behaves_like 'action :refresh #set_refresh_state'
end
