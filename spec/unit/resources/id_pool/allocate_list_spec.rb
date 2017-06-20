require_relative './../../../spec_helper'

klass = OneviewSDK::IDPool
describe 'oneview_test::id_pool_allocate_list' do
  let(:resource_name) { 'id_pool' }
  let(:ids) { ['A2:32:C3:D0:00:00', 'A2:32:C3:D0:00:01'] }
  include_context 'chef context'

  it 'allocates a list of the IDs' do
    expect_any_instance_of(klass).to receive(:validate_id_list).with('vmac', ids).and_return(true)
    expect_any_instance_of(klass).to receive(:allocate_id_list).with('vmac', ids)
    expect(real_chef_run).to allocate_oneview_id_pool_list('IDPool3')
  end
end
