require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_update_port_monitor' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  let(:provider) { OneviewCookbook::API200::LogicalInterconnectProvider }
  let(:interconnect_name) { 'interconnect1' }
  let(:unassigned_uplink_ports) { [{ 'portName' => 'Q1:3', 'uri' => '/rest/fake/Q1:3', 'interconnectName' => interconnect_name }] }
  let(:interconnect) { OneviewSDK::Interconnect.new(@client, ports: [{ 'portName' => 'd1', 'uri' => '/rest/d1' }]) }

  # Mocks the update_handler
  before(:each) do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:like?).and_return(false)
  end

  it 'updates port monitor configurations' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect)
      .to receive(:get_unassigned_uplink_ports_for_port_monitor).and_return(unassigned_uplink_ports)
    allow_any_instance_of(provider).to receive(:load_resource).with(:Interconnect, interconnect_name).and_return(interconnect)
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:update_port_monitor).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_port_monitor('LogicalInterconnect-update_port_monitor')
  end

  it 'fails when port is not found' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect)
      .to receive(:get_unassigned_uplink_ports_for_port_monitor).and_return([])
    expect { real_chef_run }.to raise_error(RuntimeError, /Port with name or uri 'Q1:3' was not found or is already being monitored/)
  end

  it 'fails when downlink port is not found' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect)
      .to receive(:get_unassigned_uplink_ports_for_port_monitor).and_return(unassigned_uplink_ports)
    allow_any_instance_of(provider).to receive(:load_resource)
      .with(:Interconnect, interconnect_name).and_return(OneviewSDK::Interconnect.new(@client, ports: []))
    expect { real_chef_run }.to raise_error(RuntimeError, /Downlink 'd1' was not found or is already being monitored/)
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end

describe 'oneview_test::logical_interconnect_update_port_monitor_data' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  # Mocks the update_handler
  before(:each) do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:like?).and_return(false)
  end

  it 'updates port monitor configurations passing the parameters in data' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:update_port_monitor).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_port_monitor('LogicalInterconnect-update_port_monitor_data')
  end
end

describe 'oneview_test::logical_interconnect_update_port_monitor_data_and_property' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  let(:provider) { OneviewCookbook::API200::LogicalInterconnectProvider }
  let(:interconnect_name) { 'interconnect1' }
  let(:unassigned_uplink_ports) { [{ 'uri' => '/rest/fake/Q1:3', 'interconnectName' => interconnect_name }] }
  let(:interconnect) { OneviewSDK::Interconnect.new(@client, ports: [{ 'portName' => 'd1', 'uri' => '/rest/d1' }]) }

  # Mocks the update_handler
  before(:each) do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:like?).and_return(false)
  end

  it 'updates port monitor configurations passing the parameters in data' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect)
      .to receive(:get_unassigned_uplink_ports_for_port_monitor).and_return(unassigned_uplink_ports)
    allow_any_instance_of(provider).to receive(:load_resource).with(:Interconnect, interconnect_name).and_return(interconnect)
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:update_port_monitor).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_port_monitor('LogicalInterconnect-update_port_monitor_data_and_property')
  end
end
