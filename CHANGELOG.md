### New
  - Upgraded Ruby SDK version to 2.0.0
  - Fixed add/create, delete/remove for resources
  - Added support to Enclosure group actions
  - Added support to Enclosure `:refresh` and `:reconfigure`
  - Added support to Ethernet network `:bulk_create`
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
  - Added diff output for updating resources
  - Added unit tests for volume template and merged `:storage_system_ip` and `:storage_system_name` into `:storage_system`

### 0.1.1
  - Fixed Ruby SDK version to 1.0.0
  - Added Stove support (using `rake`)

### 0.1.0
  - Initial release
