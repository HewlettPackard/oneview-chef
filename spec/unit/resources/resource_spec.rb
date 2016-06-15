require_relative './../../spec_helper'

describe 'oneview_test::resource' do
  include_context 'chef context'

  context 'When all attributes are default, on an unspecified platform' do
    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'creates EthernetNetwork1' do
      expect(chef_run).to create_oneview_resource('EthernetNetwork1')
    end

    it 'supports all matchers' do
      expect(chef_run).to_not create_oneview_resource('')
      expect(chef_run).to_not delete_oneview_resource('')
      expect(chef_run).to_not create_oneview_resource_if_missing('')
    end
  end
end
