## 1.4.0
 - Added oneview_scope resource

## 1.3.0
 - Added oneview_user resource

## 1.2.1
 - Update to use v4.0.0 of oneview-sdk
 - [#176](https://github.com/HewlettPackard/oneview-chef/issues/176) Support an enclosureIndex value in the oneview_enclosure_group resource's logical_interconnect_group property

## 1.2.0
Adds support to API300 by creating providers to support API200 & API300 REST APIs simultaneously.
Adds new Synergy resources.

### Refactored code
  - The following already available API200 resources had their actions put in providers and given support to API300:
    - oneview_connection_template
    - oneview_datacenter
    - oneview_enclosure
    - oneview_enclosure_group
    - oneview_ethernet_network
    - oneview_fc_network
    - oneview_fcoe_network
    - oneview_firmware
    - oneview_interconnect
    - oneview_logical_enclosure
    - oneview_logical_interconnect
    - oneview_logical_interconnect_group
    - oneview_logical_switch
    - oneview_logical_switch_group
    - oneview_managed_san
    - oneview_network_set
    - oneview_power_device
    - oneview_rack
    - oneview_resource
    - oneview_san_manager
    - oneview_server_hardware
    - oneview_server_hardware_type
    - oneview_server_profile
    - oneview_server_profile_template
    - oneview_storage_pool
    - oneview_storage_system
    - oneview_switch
    - oneview_unmanaged_device
    - oneview_uplink_set
    - oneview_volume
    - oneview_volume_template

### New features and resources
  - New actions and features in API200:
    - oneview_logical_enclosure `:create`, `:create_if_missing` and `:delete` actions
  - New actions and features in API300:
    - oneview_enclosure `:patch` action
    - oneview_server_hardware `:patch` action
    - oneview_switch `:patch` action (API300::C7000 only)
    - oneview_enclosure_group `logical_interconnect_group` (String) property was marked for deprecation in favor of `logical_interconnect_groups` (Array)
    - oneview_enclosure_group now supports SAS logical interconnect groups in property `logical_interconnect_groups`
  - New resources in API300:
    - oneview_fabric
    - oneview_sas_interconnect (API300::Synergy only)
    - oneview_sas_logical_interconnect (API300::Synergy only)
    - oneview_sas_logical_interconnect_group (API300::Synergy only)
    - oneview_drive_enclosure (API300::Synergy only)

## 1.1.0
  - Add support for client ENV variables
  - Fixed volume resource (#92) & examples

## 1.0.0
  - Added support to Volume actions `:create_snapshot` and `:delete_snapshot`
  - Added support to SAN manager actions
  - Added support to Uplink set actions
  - Added support to Logical interconnect
  - Added support to Server profile actions
  - Added support to Server profile template actions

### 0.2.0
  - Upgraded Ruby SDK version to ~> 2.1
  - Fixed add/create, delete/remove for resources
  - Added diff output for updating resources
  - Added support to Enclosure group actions
  - Added support to Enclosure `:refresh` and `:reconfigure`
  - Added support to Connection template actions
  - Integrated Connection template actions in Ethernet network within the update action, and added `:reset_connection_template` action
  - Added support to Logical enclosure `:reconfigure` and `:set_script`
  - Added support to Network set actions
  - Added support to Datacenter actions
  - Added support to Rack actions
  - Added support to Server hardware actions
  - Added support to Interconnect actions
  - Added support to Logical switch group actions
  - Added support to Logical switch actions
  - Added support to Firmware bundle actions
  - Added support to Server hardware type actions
  - Added support to Power device actions
  - Changed Storage pool action `:add` to `:add_if_missing`
  - Added support to Storage system `:edit_credentials` and `:add_if_missing`
  - Added support to Switch actions
  - Added support to Firmware driver actions and integrated it with firmware bundles in a resource called Firmware
  - Added unit tests for volume template and merged `:storage_system_ip` and `:storage_system_name` into `:storage_system`
  - Added support to Managed SAN actions
  - Added support to Unmanaged device actions

#### 0.1.1
  - Fixed Ruby SDK version to 1.0.0
  - Added Stove support (using `rake`)

### 0.1.0
  - Initial release
