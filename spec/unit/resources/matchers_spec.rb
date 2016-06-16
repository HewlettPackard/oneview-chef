require_relative './../../spec_helper'

describe 'oneview_test::default' do
  include_context 'chef context'

  it 'converges successfully' do
    chef_run # This should not raise an error
  end

  it 'supports all matchers' do
    # oneview_resource
    expect(chef_run).to_not create_oneview_resource('')
    expect(chef_run).to_not delete_oneview_resource('')
    expect(chef_run).to_not create_oneview_resource_if_missing('')

    # TODO: Add other matchers here
  end
end
