require_relative './../../../spec_helper'

klass = OneviewSDK::IDPool
describe 'oneview_test::id_pool_collect_ids' do
  let(:resource_name) { 'id_pool' }
  include_context 'chef context'

  it 'removes an list of the IDs' do
    expect_any_instance_of(klass).to receive(:collect_ids).with('vmac', ['A2:32:C3:D0:00:00', 'A2:32:C3:D0:00:01'])
    expect(real_chef_run).to collect_oneview_id_pool_ids('IDPool2')
  end
end
