require_relative './../../../spec_helper'

klass = OneviewSDK::IDPool
describe 'oneview_test::id_pool_enable' do
  let(:resource_name) { 'id_pool' }
  include_context 'chef context'
  include_context 'shared context'

  it 'enables an ID Pool' do
    fake_pool = klass.new(@client)
    allow_any_instance_of(klass).to receive(:get_pool).with('vmac').and_return(fake_pool)
    expect_any_instance_of(klass).to receive(:update).with(enabled: true).and_return(fake_pool)
    expect(real_chef_run).to enable_oneview_id_pool('IDPool1')
  end
end
