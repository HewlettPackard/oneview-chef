### New
- Added support to Volume actions `:create_snapshot` and `:delete_snapshot`
- Added support to SAN manager actions

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

## 0.1.0
  - Initial release
