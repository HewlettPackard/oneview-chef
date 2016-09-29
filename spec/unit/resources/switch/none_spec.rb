require_relative './../../../spec_helper'

describe 'oneview_test::switch_none' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'

  it 'removes it when it exists and is not in the inventory' do
    expect(real_chef_run).to none_oneview_switch('Switch1')
  end
end
