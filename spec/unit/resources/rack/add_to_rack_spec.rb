require_relative './../../../spec_helper'

describe 'oneview_test::rack_add_to_rack' do
  let(:resource_name) { 'rack' }
  include_context 'chef context'

  before :each do
    # Mount item
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('name').and_return('Encl1')
    allow_any_instance_of(OneviewSDK::Enclosure).to receive(:[]).with('uri').and_return('/rest/enclosures/encl1')
    allow_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
  end

  it 'mounts a new resource' do
    expect_any_instance_of(OneviewSDK::Rack).to receive(:add_rack_resource)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:update)
    expect(real_chef_run).to add_oneview_rack_to_rack('Rack1')
  end

  it 'mounts a resource that already exists and it is not alike' do
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('name').and_return('Rack1')
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('rackMounts').and_return(
      [
        { 'mountUri' => '/rest/enclosures/encl1', 'uHeight' => 30 }
      ]
    )
    expect_any_instance_of(OneviewSDK::Rack).to receive(:add_rack_resource)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:update)
    expect(real_chef_run).to add_oneview_rack_to_rack('Rack1')
  end

  it 'mounts a resource that already exists and it is alike' do
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('name').and_return('Rack1')
    allow_any_instance_of(OneviewSDK::Rack).to receive(:[]).with('rackMounts').and_return(
      [
        {
          'mountUri' => '/rest/enclosures/encl1',
          'uHeight' => 20
        }
      ]
    )
    expect_any_instance_of(OneviewSDK::Rack).to_not receive(:add_rack_resource)
    expect_any_instance_of(OneviewSDK::Rack).to_not receive(:update)
    expect(real_chef_run).to add_oneview_rack_to_rack('Rack1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
