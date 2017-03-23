require_relative './../../../spec_helper'

describe 'oneview_test::rack_remove_from_rack' do
  let(:resource_name) { 'rack' }
  include_context 'chef context'

  it 'removes an existing mounted resource' do
    # Mount item
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('name').and_return('Encl1')
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('uri').and_return('/rest/enclosures/encl1')

    # Rack item
    allow_any_instance_of(OneviewSDK::Rack).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('name').and_return('Rack1')
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('rackMounts').and_return(
      [
        {
          'mountUri' => '/rest/enclosures/encl1'
        }
      ]
    )
    expect_any_instance_of(OneviewSDK::Rack).to receive(:remove_rack_resource)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:update)
    expect(real_chef_run).to remove_oneview_rack_from_rack('Rack1')
  end

  it 'mounted resource does not exists' do
    # Mount item
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('name').and_return('Encl1')
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('uri').and_return('/rest/enclosures/encl1')

    # Rack item
    allow_any_instance_of(OneviewSDK::Rack).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('name').and_return('Rack1')
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('rackMounts').and_return(
      [
        {
          'mountUri' => '/rest/enclosures/encle'
        }
      ]
    )
    expect_any_instance_of(OneviewSDK::Rack).to_not receive(:remove_rack_resource)
    expect_any_instance_of(OneviewSDK::Rack).to_not receive(:update)
    expect(real_chef_run).to remove_oneview_rack_from_rack('Rack1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
