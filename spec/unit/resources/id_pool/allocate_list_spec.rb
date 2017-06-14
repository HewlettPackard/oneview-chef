require_relative './../../../spec_helper'

klass = OneviewSDK::IDPool
describe 'oneview_test::id_pool_allocate_list' do
  let(:resource_name) { 'id_pool' }
  include_context 'chef context'
  include_context 'shared context'

  it 'allocates a list of the IDs' do
    expect_any_instance_of(klass).to receive(:allocate_id_list).with('vmac', ['A2:32:C3:D0:00:00', 'A2:32:C3:D0:00:01'])
    expect(real_chef_run).to allocate_list_oneview_id_pool('IDPool3')
  end
end
