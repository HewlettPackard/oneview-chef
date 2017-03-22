require_relative './../../../spec_helper'

describe 'oneview_test::interconnect_update_port' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  let(:port_to_update) { { 'name' => 'X1', 'enabled' => false } }
  let(:port_up_to_date) { { 'name' => 'X1', 'enabled' => true } }

  it 'updates the port' do
    ports = [
      { 'name' => 'X1', 'enabled' => false },
      { 'name' => 'X2', 'enabled' => true },
      { 'name' => 'X3', 'enabled' => true }
    ]

    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:[]).with('name')
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:[]).with('ports').and_return(ports)
    expect_any_instance_of(OneviewSDK::Interconnect).to receive(:update_port).with('X1', anything).and_return(true)

    expect(real_chef_run).to update_oneview_interconnect_port('Interconnect5')
  end

  it 'leaves it as is since it is up to date' do
    ports = [
      { 'name' => 'X1', 'enabled' => true },
      { 'name' => 'X2', 'enabled' => false },
      { 'name' => 'X3', 'enabled' => false }
    ]
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:[]).with('name')
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:[]).with('ports').and_return(ports)
    expect_any_instance_of(OneviewSDK::Interconnect).to_not receive(:update_port)
    expect(real_chef_run).to update_oneview_interconnect_port('Interconnect5')
  end

  it 'fails when trying to update an unexistant port' do
    ports = [
      { 'name' => 'Z0', 'enabled' => true }
    ]
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:[]).with('name')
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:[]).with('ports').and_return(ports)
    expect { real_chef_run }.to raise_error(RuntimeError, /Could not find port/)
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end

describe 'oneview_test::interconnect_update_port_invalid' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  it 'fails if port_options property is not set' do
    allow_any_instance_of(OneviewSDK::Interconnect).to receive(:retrieve!).and_return(true)
    expect { real_chef_run }.to raise_error(RuntimeError, /Unspecified property: 'port_options'/)
  end
end
