require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_group_set_script' do
  let(:resource_name) { 'enclosure_group' }
  include_context 'chef context'

  it 'script is already up to date' do
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:get_script).and_return('hello, world!')
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to_not receive(:set_script).with('hello, world!')
    expect(real_chef_run).to set_oneview_enclosure_group_script('EnclosureGroup3')
  end

  it 'updates script' do
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:get_script).and_return('')
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:set_script).with('hello, world!').and_return(true)
    expect(real_chef_run).to set_oneview_enclosure_group_script('EnclosureGroup3')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
