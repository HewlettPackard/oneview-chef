require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_logical_interconnect_replace_drive_enclosure' do
  let(:resource_name) { 'sas_logical_interconnect' }
  let(:base_sdk) { OneviewSDK::API300::Synergy }
  let(:klass) { OneviewSDK::API300::Synergy::SASLogicalInterconnect }
  let(:provider) { OneviewCookbook::API300::Synergy::SASLogicalInterconnectProvider }
  include_context 'chef context'

  before(:each) do
    allow_any_instance_of(provider).to receive(:context).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(klass).to receive(:[]).and_call_original
  end

  it 'replaces the drive enclosures by name' do
    # Create a new Drive Enclosure
    # Retrieves and returns the SNs
    allow_any_instance_of(provider).to receive(:load_resource).with(:DriveEnclosure, 'OLD_DRIVE', 'serialNumber')
                                                              .and_return('SNFAKE1')
    allow_any_instance_of(provider).to receive(:load_resource).with(:DriveEnclosure, 'NEW_DRIVE', 'serialNumber')
                                                              .and_return('SNFAKE2')
    # It finds the resource
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    # It calls the replace method
    expect_any_instance_of(klass).to receive(:replace_drive_enclosure).with('SNFAKE1', 'SNFAKE2').and_return(true)
    expect(real_chef_run).to replace_oneview_sas_logical_interconnect_drive_enclosure('SASLogicalInterconnect-replace_drive_enclosure')
  end

  it 'replaces the drive enclosures by serial number' do
    # Drive enclosures cannot be found by name
    allow_any_instance_of(base_sdk::DriveEnclosure).to receive(:retrieve!).and_return(false)
    # allow(base_sdk::DriveEnclosure).to receive(:find_by).with(anything, name: 'NEW_DRIVE').and_return([])
    # It finds the resource
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    # It calls the replace method
    expect_any_instance_of(klass).to receive(:replace_drive_enclosure).with('OLD_DRIVE', 'NEW_DRIVE').and_return(true)
    expect(real_chef_run).to replace_oneview_sas_logical_interconnect_drive_enclosure('SASLogicalInterconnect-replace_drive_enclosure')
  end

  it 'replaces the drive enclosures by serial number inside data' do
    # Check the data first and find the serials
    specified_data = {
      'oldSerialNumber' => 'SNFAKE1',
      'newSerialNumber' => 'SNFAKE2'
    }
    allow_any_instance_of(klass).to receive(:data).and_return(specified_data)
    # It finds the resource
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    # It calls the replace method
    expect_any_instance_of(klass).to receive(:replace_drive_enclosure).with('SNFAKE1', 'SNFAKE2').and_return(true)
    expect(real_chef_run).to replace_oneview_sas_logical_interconnect_drive_enclosure('SASLogicalInterconnect-replace_drive_enclosure')
  end

  it 'fails if the old drive enclosure is not specified' do
    # Check the data first and find the serials
    # Old drive enclosure cannot be found by name
    allow_any_instance_of(provider).to receive(:load_resource).with(:DriveEnclosure, 'OLD_DRIVE', 'serialNumber')
                                                              .and_return(nil)
    expect_any_instance_of(klass).to_not receive(:replace_drive_enclosure)
    expect { real_chef_run }.to raise_error(RuntimeError, /InvalidParameters: Old drive enclosure/)
  end

  it 'fails if the new drive enclosure is not specified' do
    # Check the data first and find the serials
    # New drive enclosure cannot be found by name
    allow_any_instance_of(provider).to receive(:load_resource).with(:DriveEnclosure, 'OLD_DRIVE', 'serialNumber')
                                                              .and_return('SNFAKE1')
    allow_any_instance_of(provider).to receive(:load_resource).with(:DriveEnclosure, 'NEW_DRIVE', 'serialNumber')
                                                              .and_return(nil)
    expect_any_instance_of(klass).to_not receive(:replace_drive_enclosure)
    expect { real_chef_run }.to raise_error(RuntimeError, /InvalidParameters: New drive enclosure/)
  end

  it 'fails if the SAS logical interconnect is not found' do
    # Check the data first and find the serials
    allow_any_instance_of(provider).to receive(:load_resource).with(:DriveEnclosure, 'OLD_DRIVE', 'serialNumber')
                                                              .and_return('SNFAKE1')
    allow_any_instance_of(provider).to receive(:load_resource).with(:DriveEnclosure, 'NEW_DRIVE', 'serialNumber')
                                                              .and_return('SNFAKE2')
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(klass).to_not receive(:replace_drive_enclosure)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
