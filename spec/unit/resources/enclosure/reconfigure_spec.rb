require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_reconfigure' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  it 'reconfigure enclosure already triggered' do
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('reconfigurationState')
                                                                .and_return('Pending')
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('name')
                                                                .and_return('Enclosure1')
    expect_any_instance_of(OneviewSDK::Enclosure).to_not receive(:configuration).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_enclosure('Enclosure1')
  end

  it 'reconfigure enclosure with default options' do
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('reconfigurationState')
                                                                .and_return('NotReapplyingConfiguration')
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('name')
                                                                .and_return('Enclosure1')
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:configuration).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_enclosure('Enclosure1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
