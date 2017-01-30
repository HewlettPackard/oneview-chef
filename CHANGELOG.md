## Unreleased
  - Support oneview-sdk v3.0 & different API versions/modules
  - ethernet_network support for API300
  - fc_network support for API300
  - fcoe_network support for API300
  - network_set support for API300
  - datacenter support for API300
  - fabric new resource support for API300 Synergy
  - san_manager support for API300
  - rack support for API300
  - managed_san support for API300
  - server_hardware_type resource for API300
  - power_device support for API300
  - unmanaged_device support for API300
  - logical_interconnect support for API300
  - enclosure_group support for API300
  - firmware support for API300
  - storage_system support for API300
  - storage_pool support for API300
  - logical_switch_group support for API300
  - logical_interconnect_group support for API300
  - Deprecate enclosure_group property 'logical_interconnect_group' (string) in favor of 'logical_interconnect_groups' (array)
    - Also supports SAS LIGs for Synergy in this logical_interconnect_groups property
  - volume support for API300
  - volume_template support for API300
  - enclosure support for API300. Also added `:patch` action

### 1.1.0
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
