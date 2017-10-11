## 3.0.0
Adds API 500 support to the following HPE OneView resources:
  - oneview_connection_template
  - oneview_datacenter
  - oneview_drive_enclosure
  - oneview_enclosure
  - oneview_enclosure_group
  - oneview_ethernet_network
  - oneview_event
  - oneview_fabric
  - oneview_fc_network
  - oneview_fcoe_network
  - oneview_firmware
  - oneview_id_pool
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
  - oneview_san_manager
  - oneview_sas_interconnect
  - oneview_sas_logical_interconnect
  - oneview_sas_logical_interconnect_group
  - oneview_scope
  - oneview_server_hardware
  - oneview_server_hardware_type
  - oneview_server_profile
  - oneview_server_profile_template
  - oneview_storage_pool
  - oneview_storage_system
  - oneview_switch
  - oneview_unmanaged_device
  - oneview_uplink_set
  - oneview_user
  - oneview_volume
  - oneview_volume_template

Adds testing documentation into `TESTING.md`

Enhancements:
- [#225](https://github.com/HewlettPackard/oneview-chef/issues/225) Support additional uplink port types in the LogicalInterconnectGroupProvider
- [#246](https://github.com/HewlettPackard/oneview-chef/issues/246) Upgrade oneview-sdk gem to version 5.0.0
- [#247](https://github.com/HewlettPackard/oneview-chef/issues/247) Remove deprecation and warnings for Chef 13
- [#304](https://github.com/HewlettPackard/oneview-chef/issues/304) Add refresh actions to oneview_storage_system
- [#306](https://github.com/HewlettPackard/oneview-chef/issues/306) Create shared examples to unit tests that using scope actions
- [#309](https://github.com/HewlettPackard/oneview-chef/issues/309) Add volume_attachment property to Server Profiles and SP Templates so VAs can be more easily managed
- [#336](https://github.com/HewlettPackard/oneview-chef/issues/336) Remove :new_profile action of oneview_server_profile_template
- [#343](https://github.com/HewlettPackard/oneview-chef/issues/343) Use helper method of OneviewSDK StoragePool to set StorageSystem to a StoragePool of API500

Bug fixes:
- [#180](https://github.com/HewlettPackard/oneview-chef/issues/180) Create Mixins for the resource providers common methods
- [#243](https://github.com/HewlettPackard/oneview-chef/issues/243) Chef-client 13.2.20 does not allow modification of property :save_resource_info
- [#284](https://github.com/HewlettPackard/oneview-chef/issues/284) Nested and cyclic requires are causing the first resource to be skipped
- [#287](https://github.com/HewlettPackard/oneview-chef/issues/287) Disable FrozenString magic comment cop from Rubocop until the support is done
- [#340](https://github.com/HewlettPackard/oneview-chef/issues/340) Storage pool actions for API 500 are not working

### Breaking changes
- The `:new_profile` action was removed from oneview_server_profile_template and incorporated into create and update actions of the `oneview_server_profile` resource where a `server_profile_template` is specified.

## 2.3.0
Adds support to the following HPE OneView resources:
  - Added oneview_event resource
  - Added oneview_id_pool resource

Enhancements:
- [#233](https://github.com/HewlettPackard/oneview-chef/issues/233) ServerProfile connections cannot have more than one connection with the same network
- [#234](https://github.com/HewlettPackard/oneview-chef/issues/234) Server Profile does not fill default values for OS Custom Attributes automatically

Bug Fixes:
- [#231](https://github.com/HewlettPackard/oneview-chef/issues/231) Fix Foodcritic FC069
- [#232](https://github.com/HewlettPackard/oneview-chef/issues/232) Server Profile with os_deployment_plan property is not setting osCustomAttributes correctly
- [#240](https://github.com/HewlettPackard/oneview-chef/issues/240) Wrong operator in ServerProfile warning

## 2.2.1
Enhancements:
- [#228](https://github.com/HewlettPackard/oneview-chef/issues/228) Add ::load_resource method to OneviewCookbook::Helper

## 2.2.0
Adds full support the HPE Synergy Image Streamer API300. It also fixes some bugs and adds important enhancements.

New resources added for HPE Synergy Image Streamer API300:
  - image_streamer_artifact_bundle
  - image_streamer_os_build_plan

Bug Fixes:
- [#93](https://github.com/HewlettPackard/oneview-chef/issues/93) oneview_storage_system should not try to update the name
- [#98](https://github.com/HewlettPackard/oneview-chef/issues/98) Fix get_diff for comparisons of alike data
- [#145](https://github.com/HewlettPackard/oneview-chef/issues/145) Show diff on log statement before actual update
- [#220](https://github.com/HewlettPackard/oneview-chef/issues/220) Raise "not found" error after failed retrieval of resource

Enhancements:
- [#217](https://github.com/HewlettPackard/oneview-chef/issues/217) Create full server deploy example recipe using Image Streamer and OneView resources
- [#218](https://github.com/HewlettPackard/oneview-chef/issues/218) connection_template resource does not support NetworkSet, FCoENetwork and FCNetwork

## 2.1.0
- [#162](https://github.com/HewlettPackard/oneview-chef/issues/162) Add server_profile_template property to oneview_server_profile
- Add :update_from_template action to oneview_server_profile
- Adds support to API300 HPE Synergy Image Streamer resources:
  - image_streamer_deployment_plan
  - image_streamer_golden_image

# 2.0.0
Adds support to the following HPE OneView resources:
  - Added oneview_scope resource (API 300 only)

Adds support to API300 HPE Synergy Image Streamer resources:
  - image_streamer_plan_script

### Breaking changes
 - The resource api version selector now considers using the client's api version before falling back to the node['oneview']['api_version'] attribute as a default. (Order of precedence: resource api_version property > client's api_version attribute > node attribute)
 - oneview_enclosure's property `state` renamed to `refresh_state`
 - oneview_managed_san's action `:set_refresh_state` renamed to `:refresh`. Also it gained the property `refresh_state`

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

# 1.0.0
Now the cookbook can operate with all the supported OneView 2.0 (API200) resources. Also added some bug fixes and minor improvements.
  - Added support to Volume actions `:create_snapshot` and `:delete_snapshot`
  - Added support to SAN manager actions
  - Added support to Uplink set actions
  - Added support to Logical interconnect
  - Added support to Server profile actions
  - Added support to Server profile template actions

### 0.2.0
Adds new resources, shared features and bug fixes. Also upgrades the Ruby SDK version to ~> 2.1.
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

## 0.1.1
  - Fixed Ruby SDK version to 1.0.0
  - Added Stove support (using `rake`)
  - Fixed the oneview-sdk gem to `v1.0.0` (the version can be changed in the `/attributes/default.rb`, but doing this may result in failures in some actions for some resources)

## 0.1.0 (Initial release)
In the future, there will be individual Chef resources for each OneView resource.
However, at this beta stage, only a subset of specific resources and a generic `oneview_resource` are available.
(The generic one will continue to exist, so don't worry about having to rewrite everything when additional resources are added.)
With the generic model, you may find that particular resources don't support certain actions or have slightly different behaviors.
Here are some known issues with different resource types:
 - **EnclosureGroup** - Since the script is at a separate API endpoint, we can't set that here.

 - **FCNetwork** - Fails when action is `:create` and `connectionTemplateUri` is set to `nil` (because OV sets it). Leave it out instead of setting it to `nil`.

 - **FCoENetwork** - Fails when action is `:create` and `connectionTemplateUri` is set to `nil` (because OV sets it). Leave it out instead of setting it to `nil`.

 - **ServerHardware** - Requires Chef `name` parameter to be set to the hostname/IP in order to work. Also, updates won't work because the resource doesn't support it. Use `:create_if_missing` action only
