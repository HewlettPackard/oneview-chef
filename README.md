# Cookbook for HPE OneView

[![Cookbook Version](https://img.shields.io/cookbook/v/oneview.svg)](https://supermarket.chef.io/cookbooks/oneview)
[![Yard Docs](https://img.shields.io/badge/yard-docs-yellow.svg)](http://www.rubydoc.info/github/HewlettPackard/oneview-chef)

[![Travis Build Status](https://travis-ci.org/HewlettPackard/oneview-chef.svg?branch=master)](https://travis-ci.org/HewlettPackard/oneview-chef)
[![Chef Build Status](https://jenkins-01.eastus.cloudapp.azure.com/job/oneview-cookbook/badge/icon)](https://jenkins-01.eastus.cloudapp.azure.com/job/oneview-cookbook/)
[![Code Climate](https://codeclimate.com/github/HewlettPackard/oneview-chef/badges/gpa.svg)](https://codeclimate.com/github/HewlettPackard/oneview-chef)
[![Test Coverage](https://codeclimate.com/github/HewlettPackard/oneview-chef/badges/coverage.svg)](https://codeclimate.com/github/HewlettPackard/oneview-chef/coverage)

Chef cookbook that provides resources for managing HPE OneView.

## Requirements
 - Ruby 2.2.6 or higher (We recommend using Ruby 2.4.1 or higher)
 - Chef 12.0 or higher (We recommend using Chef 13.12 or higher if possible)
 - For oneview resources: HPE OneView 2.0, 3.0 or 3.10 (API versions 200, 300 or 500). May work with other versions too, but no guarantees
 - For image_streamer resources: HPE Synergy Image Streamer appliance (API version 300)

## Usage
This cookbook is not intended to include any recipes.
Use it by creating a new cookbook and specifying a dependency on this cookbook in your metadata.
Then use any of the resources provided by this cookbook.

```ruby
# my_cookbook/metadata.rb
...
depends 'oneview', '~> 3.0.0'
```

### Credentials
In order to manage HPE OneView and HPE Synergy Image Streamer resources, you will need to provide authentication credentials. There are 2 ways to do this:

1. Set the environment variables:
  - For HPE OneView: ONEVIEWSDK_URL, ONEVIEWSDK_USER, ONEVIEWSDK_PASSWORD, and/or ONEVIEWSDK_TOKEN.
  - For HPE Synergy Image Streamer: I3S_URL and ONEVIEWSDK_TOKEN, or ONEVIEWSDK_URL, ONEVIEWSDK_USER and ONEVIEWSDK_PASSWORD.
  See [this](https://github.com/HewlettPackard/oneview-sdk-ruby#environment-variables) for more info.
2. Explicitly pass in the `client` property to each resource (see the [Resource Properties](#resource-properties) section below). This takes precedence over environment variables and allows you to set more client properties. This also allows you to get these credentials from other sources like encrypted databags, Vault, etc.

HPE Synergy Image Streamer access token is the same as the HPE OneView associated appliance, so most of its credentials you may get from the HPE OneView.

### API version
When using the resources a API version will be selected to interact with the resources in each HPE OneView correct API versions. To select the desired one, you may use one of the following methods:

1. Set the resource property `api_version`. See the [Resource Properties](#resource-properties) section below.
2. Set the client parameter `api_version`. If this parameter is set, it will select the required API version based on the client. Notice if you choose to pass the client as an OneviewSDK object, it will have, by default, the api_version set, even if you do not directly specify it.
3. If none of the previous alternatives are set, it defaults to the `node['oneview']['api_version']`. See the [Atributes](#attributes).

Be aware of the precedence of these methods! The higher priority goes to setting the resource property, followed by the client parameter, and at last the node value as the default, i.e. *Property > Client > Attribute*. (e.g. If you set the resource property `api_version` to *200*, and set the client parameter `api_version` to *300*, it will use the module **API200**, since the resource property takes precedence over the client parameter)

## Attributes
 - `node['oneview']['ruby_sdk_version']` - Set which version of the SDK to install and use. Defaults to `'~> 4.1'`
 - `node['oneview']['save_resource_info']` - Save resource info to a node attribute? Defaults to `['uri']`. Possible values/types:
   - `true` - Save all info (Merged hash of OneView info and Chef resource properties). Warning: Resource credentials will be saved if specified.
   - `false` - Do not save any info.
   - `Array` - i.e. `['uri', 'status', 'created_at']` Save a subset of specified attributes.
 - `node['oneview']['api_version']` - When looking for a matching Chef resource provider class, this version will be used as default. Defaults to `200`.
 - `node['oneview']['api_variant']` - When looking for a matching Chef resource provider class, this variant will be used as default. Defaults to `C7000`.

See [attributes/default.rb](attributes/default.rb) for more info.

## Resources

### Resource Properties
The following are the standard properties available for all resources. Some resources have additional properties or small differences; see their doc sections below for more details.

 - **client**: Hash, OneviewSDK::Client or OneviewSDK::ImageStreamer::Client object that contains information about how to connect to the HPE OneView or HPE Synergy Image Streamer instances.
   - For HPE OneView required attributes are: `url` and `token` or `user` and `password`.
   - For HPE Synergy Image Streamer required attributes are: `url` and, `token` or `oneview_client`.
 See [this](https://github.com/HewlettPackard/oneview-sdk-ruby#configuration) for more options.
 - **data**: Hash specifying options for this resource. Refer to the OneView API docs for what's available and/or required. If no name attribute is given, it will use the name given to the Chef resource.
   - :information_source: Tip: In addition to the API docs, you can use the [oneview-sdk gem's CLI](https://github.com/HewlettPackard/oneview-sdk-ruby#cli) to quickly show information about resources. If you're wanting to know which data properties exist for a resource, it might make sense to create a resource on the Web UI, then view the data. For example, after creating a new ethernet network named `eth1`, run `$ oneview-sdk-ruby show EthernetNetwork eth1`
 - **action**: Symbol specifying what to do with this resource. Options for most resources (**some may differ**):
   - `:create` - (Default) Ensure this resource exists and matches the data given.
   - `:create_if_missing` - Ensure this resource exists, but don't ensure it is up to date on subsequent chef-client runs.
   - `:delete` - Delete this resource from OneView. For this, you only need to specify the resource name or uri in the data section.
 - **save_resource_info**: Defaults to `node['oneview']['save_resource_info']` (see the attribute above). Doesn't apply to the `:delete` action
   - Once the resource is created, you can access this data at `node['oneview'][<oneview_url>][<resource_name>]`. This can be useful to extract URIs from other resources, etc.
 - **api_version**: (Integer) Specify the version of the [API module](libraries/resource_providers/) to use.
 - **api_variant**: (String) When looking for resources in the specified API module, this version will be used. Defaults to `node['oneview']['api_variant']`
 - **api_header_version**: (Integer) This will override the version used in API request headers. Only set this if you know what you're doing.
 - **operation**: (String) Specify the operation to be performed by a `:patch` action.
 - **path**: (String) Specify the path where the `:patch` action will be sent to.
 - **value**: (String, Array<String>) Specify the value for the `:patch` action. Optional for some operations.

### [oneview_resource](examples/oneview_resource.rb)
This is a generic provider for managing any OneView resource.
This really exists only for resources that exist in the SDK but don't have a Chef resource provider. If a specific resource exists, please use it instead.

The basic usage is as follows:

```ruby
oneview_resource 'name' do
  client <my_client>   # Hash or OneviewSDK::Client
  type <resource_type> # String or Symbol
  data <resource_data> # Hash
  action [:create, :create_if_missing, :delete] # (Choose only 1)
end
```

**type:** String or Symbol corresponding to the name of the resource type. For example, `EthernetNetwork`, `Enclosure`, `Volume` etc. These should line up with the OneView SDK resource classes listed [here](https://github.com/HewlettPackard/oneview-sdk-ruby/tree/master/lib/oneview-sdk/resource).

See the [example](examples/oneview_resource.rb) for more details.

### [oneview_ethernet_network](examples/ethernet_network.rb)
Note: The `:bandwidth` can be defined inside `data` attribute. However, it will internally call the **oneview_connection_template** resource.

```ruby
oneview_ethernet_network 'Eth1' do
  client <my_client>
  data <resource_data>
  operation <op>       # String. Used in patch action only. e.g., 'replace'
  path <path>          # String. Used in patch option only. e.g., '/name'
  value <val>          # String, Array. Used in patch option only. e.g., 'New Name'
  scopes <scope_names> # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:create, :create_if_missing, :delete, :reset_connection_template, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

### [oneview_connection_template](examples/connection_template.rb)

```ruby
oneview_connection_template 'ConnectionTemplate1' do
  client <my_client>
  data <resource_data>
  associated_ethernet_network <ethernet_network_name> # Or
  associated_fcoe_network <fcoe_network_name> # Or
  associated_fc_network <fc_network_name> # Or
  associated_network_set <network_set_name>
  action [:update, :reset]
end
```

:memo: **Note:** This resource can be used to set connection template parameters within four OneView entities: `EthernetNetwork`, `FCoENetwork`, `FCNetwork` and `NetworkSet`. However you cannot manipulate more than one associated resource in a single connection template.

Although the names of the associated resources (`associated_ethernet_network`, `associated_fcoe_network`, `associated_fc_network` and `associated_network_set`) are optional parameters, they must be set if the correct URI and Connection template name are not defined.

### [oneview_fabric](examples/fabric.rb)
Performs updates on the reserved vlan range.

Note: Supported only in API300 onwards with the Synergy variant.

```ruby
oneview_fabric 'Fabric1' do
  client <my_client>
  data <resource_data>
  reserved_vlan_range <vlan_options> # Hash: Usually the 'start' and 'length' of the range
  action [:set_reserved_vlan_range]
end
```

### [oneview_fc_network](examples/fc_network.rb)

```ruby
oneview_fc_network 'Fc1' do
  client <my_client>
  data <resource_data>
  associated_san <san_name> # String - Optional. Can also set managedSanUri in data
  operation <op>            # String. Used in patch action only. e.g., 'add'
  path <path>               # String. Used in patch option only. e.g., '/scopeUris/-'
  value <val>               # String. Used in patch option only. e.g., 'scope uri'
  scopes <scope_names>      # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:create, :create_if_missing, :delete, :reset_connection_template, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```


### [oneview_fcoe_network](examples/fcoe_network.rb)

```ruby
oneview_fcoe_network 'FCoE1' do
  client <my_client>
  data <resource_data>
  associated_san <san_name> # String - Optional. Can also set managedSanUri in data
  path <path>               # String. Used in patch option only. e.g., '/scopeUris/-'
  value <val>               # String. Used in patch option only. e.g., 'scope uri'
  scopes <scope_names>      # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:create, :create_if_missing, :delete, :reset_connection_template, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

### [oneview_network_set](examples/network_set.rb)

```ruby
oneview_network_set 'NetSet1' do
  client <my_client>
  native_network <native_network_name>  # String: Optional
  ethernet_network_list <networks_list> # Array of network names as Strings: Optional
  data <resource_data>
  operation <op>       # String. Used in patch action only. e.g., 'replace'
  path <path>          # String. Used in patch option only. e.g., '/name'
  value <val>          # String, Array. Used in patch option only. e.g., 'New Name'
  scopes <scope_names> # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:create, :create_if_missing, :delete, :reset_connection_template, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

### [oneview_event](examples/event.rb)

```ruby
oneview_event 'Event1' do
  client <my_client>
  data <resource_data>
  action [:create]
end
```

### [oneview_firmware](examples/firmware.rb)
Resource for HPE OneView firmware bundles and drivers.

```ruby
oneview_firmware '/full/path/to/file.iso'  do
  client <my_client>
  action [:add, :remove]
end

oneview_firmware 'firmware_bundle_name'  do
  client <my_client>
  action :remove
end
```

```ruby
oneview_firmware 'CustomSPP'  do
  client <my_client>
  spp_name 'SPPName'
  hotfixes_names [
    'hotfix1_name'
  ]
  action :create_custom_spp
end
```

### [oneview_interconnect](examples/interconnect.rb)
Performs the Interconnect actions:
  - **reset:** Resets the Interconnect.
  - **reset_port_protection:** Resets the Interconnect port protection.
  - **update_port:** Updates one specified port in the Interconnect. The Hash property `port_options` is required, and is also needed to specify the key `"name"` corresponding to the port name. (E.G.: "X1", "Q1.1")
  - **set_uid_light:** Sets the Interconnect UID indicator (UID light) to the specified value. The String property `uid_light_state` is required, and typically assumes the "On" and "Off" values.
  - **power_state:** Sets the Interconnect power state to the specified value. The String property `power_state` is required, and typically assumes the "On" and "Off" values.

```ruby
oneview_interconnect 'Interconnect1' do
  client <my_client>
  data <resource_data>
  port_options <port_data_hash>            # Required for :update_port
  uid_light_state <uid_light_state_string> # Required for :set_uid_light
  power_state <power_state_string>         # Required for :set_power_state
  action [:reset, :reset_port_protection, :update_port, :set_uid_light, :set_power_state]
end
```

### [oneview_sas_interconnect](examples/sas_interconnect.rb)
Note: This is a Synergy-only resource.

Performs the SAS interconnect actions:
  - **reset:** Soft resets the SAS interconnect. Reset the management processor and will not disrupt I/O.
  - **hard_reset:** Hard resets the SAS interconnect. Reset the interconnect and will interrupt active I/O.
  - **set_uid_light:** Sets the SAS interconnect UID indicator (UID light) to the specified value. The String property `uid_light_state` is required, and typically assumes the "On" and "Off" values.
  - **power_state:** Sets the SAS interconnect power state to the specified value. The String property `power_state` is required, and typically assumes the "On" and "Off" values.
  - **patch:** Performs a patch operation. The properties `operation`, `path` and `value` are used for this action.
  - **refresh:** Initiates a refresh process in the SAS interconnect. The default refresh process ('RefreshPending') can be overrided using the `refresh_state` property.

```ruby
oneview_sas_interconnect 'SASInterconnect1' do
  client <my_client>
  data <resource_data>
  uid_light_state <uid_light_state_string> # Required for :set_uid_light
  power_state <power_state_string>         # Required for :set_power_state
  refresh_state <refresh_state_string>     # Default: 'RefreshPending'. String that defines the desired refresh state in :refresh action
  operation <op>                           # String. Used in patch action only. e.g., 'replace'
  path <path>                              # String. Used in patch option only. e.g., '/name'
  value <val>                              # String, Array. Used in patch option only. e.g., 'New Name'
  action [:reset, :hard_reset, :set_uid_light, :set_power_state, :patch, :refresh]
end
```

### [oneview_logical_interconnect](examples/logical_interconnect.rb)
Performs actions on logical interconnect and associated interconnects.

Note: By default it performs the action `:none`.

Note: In the `:update_port_monitor` action, if the same field is informed inside both `data` and `port_monitor`, the value of that field inside `data` will supersede the value inside `port_monitor`.

```ruby
oneview_logical_interconnect 'LogicalInterconnect1' do
  client <my_client>
  data <resource_data>
  firmware <firmware_name>            # String: Optional for actions like :<action>_firwmare (can be replaced by data attribute 'sppName')
  firmware_data <firmware_data>       # Hash: Optional for actions like :<action>_firwmare
  internal_networks <networks_names>  # Array: Optional for :update_internal_networks
  trap_destinations <trap_options>    # Hash: Optional for :update_snmp_configuration
  enclosure <enclosure_name>          # String: Required for :add_interconnect and :remove_interconnect
  bay_number <bay>                    # Integer: Required for :add_interconnect and :remove_interconnect
  port_monitor <port_monitor_options> # Hash: Optional for :update_port_monitor
  operation <op>                      # String. Used in patch action only. e.g., 'add'
  path <path>                         # String. Used in patch option only. e.g., '/scopeUris/-'
  value <val>                         # String. Used in patch option only. e.g., 'scope uri'
  scopes <scope_names>                # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:none, :add_interconnect, :remove_interconnect, :update_internal_networks,
          :update_settings,:update_ethernet_settings, :update_port_monitor, :update_qos_configuration,
          :update_telemetry_configuration, :update_snmp_configuration, :update_firmware, :stage_firmware,
          :activate_firmware, :update_from_group, :reapply_configuration, :patch, :add_to_scopes,
          :remove_from_scopes, :replace_scopes]
end
```

### [oneview_sas_logical_interconnect](examples/sas_logical_interconnect.rb)
Note: By default it performs the action `:none`.

```ruby
oneview_sas_logical_interconnect 'SASLogicalInterconnect1' do
  client <my_client>
  data <resource_data>
  firmware <firmware_name>                      # String (Optional): for actions like :<action>_firwmare (can be replaced by data attribute 'sppName')
  firmware_data <firmware_data>                 # Hash: Optional for actions like :<action>_firwmare
  old_drive_enclosure <old_drive_enclosure_id>  # String (Optional): Old Drive enclosure name or serial number. It is used with the action :replace_drive_enclosure.
  new_drive_enclosure <new_drive_enclosure_id>  # String (Optional): New Drive enclosure name or serial number. It is used with the action :replace_drive_enclosure.
  action [:none, :update_firmware, :stage_firmware, :activate_firmware, :update_from_group,
          :reapply_configuration, :replace_drive_enclosure]
end
```
  - **replace_drive_enclosure:** After a drive enclosure is *physically replaced* it initiates the replace process. The `old_drive_enclosure` and `new_drive_enclosure` properties can be specified, they can be either the names or serial numbers of the drive enclosures. Additionally they can be replaced by specifying the serial number directly into the `data` property the keys `:oldSerialNumber` and `:newSerialNumber`. (This option has the best performance)

### [oneview_logical_interconnect_group](examples/logical_interconnect_group.rb)
This resource provides creation at three different levels:
 1. The base one where you just specify the name and some configuration parameters.
 2. Next one where you specify the interconnect types with the corresponding bays.
 3. The most complete way, where you can also specify the uplink sets for your group. (It is also possible to add and edit them later using the `oneview_uplink_set` resource)

The `:create` action will always update the Logical Interconnect Group if you use the creation modes 2 and 3. So if you want to avoid this, use the action `:create_if_missing`

```ruby
oneview_logical_interconnect_group 'LogicalInterconnectGroup_1' do
  client <my_client>
  data <resource_data>
  interconnects <interconnects_data> # Array of hashes specifying interconnect data
  uplink_sets <uplink_set_data>      # Array of hashes specifying uplink data
  operation <op>         # String. Used in patch action only. e.g., 'replace'
  path <path>            # String. Used in patch option only. e.g., '/name'
  value <val>            # String, Array. Used in patch option only. e.g., 'New Name'
  scopes <scope_names> # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:create, :create_if_missing, :delete, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

**interconnects:** Array of Hashes indicating the interconnect location and type. Each hash should contain the keys:
  - `:bay` - It specifies the location (bay) where this interconnect is attached to. The value should range from 1 to 8.
  - `:type` - The interconnect type name that is currently attached to your enclosure.
  - `:enclosure_index` - enclosureIndex value for the interconnect. API300::Synergy only.
  - `:logical_downlink` - Name of the LogicalDownlink for the interconnect. API300::Synergy only.

```ruby
interconnects_data = [
  { bay: 1, type: 'HP VC FlexFabric 10Gb/24-Port Module' },
  { bay: 2, type: 'HP VC FlexFabric 10Gb/24-Port Module', enclosureIndex: 2 }
]
```

**uplink_sets:** Array of Hashes describing each uplink set that should be present in the group. Each hash should contain the keys:
  - `:data` - A Hash containing the name, type, and subtype if needed:
    - `:name` - The name of the Uplink set.
    - `:networkType` - The type of the Uplink set. The values supported are 'Ethernet' and 'FibreChannel'.
    - `:ethernetNetworkType` - The type of the EthernetNetwork. It only should be used if `:networkType` is 'Ethernet'.

    ```ruby
    uplink_data = {
      name: 'LogicalInterconnectGroup_1_UplinkSet_1',
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged'
    }
    ```

  - `:connections` - Array of Hashes containing the association of bay and the port name. The keys for each Hash are:
    - `:bay` - Number of the bay the interconnect is attached to identify in which interconnect the uplink will be created.
    - `:port` - The name of the port of the interconnect. It may change depending on the interconnect type.
    - `:type` - The type of the interconnect module i.e 'Virtual Connect SE 40Gb F8 Module for Synergy'
    - `:enclosure_index` - enclosureIndex value for the uplink. API300::Synergy only

    c7000 Enclosure example:

    ```ruby
    uplink_connections = [
      { bay: 1, port: 'X5' },
      { bay: 2, port: 'X7' }
    ]
    ```

    Synergy frame example:

    ```ruby
    uplink_connections = [
      { bay: 3, port: 'Q1', type: 'Virtual Connect SE 40Gb F8 Module for Synergy', enclosure_index: 1 },
      { bay: 6, port: 'Q1', type: 'Virtual Connect SE 40Gb F8 Module for Synergy', enclosure_index: 2 }
    ]
    ```

  - `:networks` - An array containing the names of the networks with the associated Uplink set. The networks should be created prior to the execution of this resource. Remember to match Ethernet networks for Ethernet Uplink sets, and one FC Network for FibreChannel Uplink sets.

  At the end we may have an array of Hashes like this to be used in the property:

  ```ruby
  uplink_set_data = [
    { data: uplink_data_1,  connections: uplink_connections_1, networks: ['Ethernet_1', 'Ethernet_2'] },
    { data: uplink_data_2,  connections: uplink_connections_2, networks: ['FC_1'] }
  ]
  ```

### [oneview_sas_logical_interconnect_group](examples/sas_logical_interconnect_group.rb)
Note: This is a Synergy-only resource.

```ruby
oneview_sas_logical_interconnect_group 'SAS_LIG_1' do
  client <my_client>
  data <resource_data>
  interconnects <interconnects_data> # Array specifying the interconnects in the bays
  action [:create, :create_if_missing, :delete]
end
```

**interconnects:** Array containing a list of Hashes indicating whether the interconnects are and which type they correspond to. Each hash should contain the keys:
  - `:bay` - It specifies the location (bay) where this interconnect is attached to. The value should range from 1 to 8.
  - `:type` - The interconnect type name that is currently attached to your enclosure.

```ruby
interconnects_data = [
  { bay: 1, type: 'Synergy 12Gb SAS Connection Module' },
  { bay: 4, type: 'Synergy 12Gb SAS Connection Module' }
]
```

### [oneview_logical_switch_group](examples/logical_switch_group.rb)

```ruby
oneview_logical_switch_group 'LogicalSwitchGroup_1' do
  client <my_client>
  data <resource_data>           # Switch options
  switch_number <number>         # Specify how many switches are in the group
  switch_type <switch_type_name> # Specify the type of the switches for the entire group
  operation <op>                 # String. Used in patch action only. e.g., 'add'
  path <path>                    # String. Used in patch option only. e.g., '/scopeUris/-'
  value <val>                    # String. Used in patch option only. e.g., 'scope uri'
  scopes <scope_names>           # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:create, :create_if_missing, :delete, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

The `:create` and `create_if_missing` can be done in two different ways:
  1. By specifying the 'switchMapTemplate' attribute in the `data` property
  2. By specifying both `switch_number` and `switch_type` properties, but no 'switchMapTemplate' attribute in the `data` property

:memo: **Note:** You are still able to specify the `switch_number` and `switch_type` properties even if you use the 'switchMapTemplate' attribute, but they will be **ignored**, only the values from 'switchMapTemplate' are going to be used.

### [oneview_logical_switch](examples/logical_switch.rb)

```ruby
oneview_logical_switch 'LogicalSwitch_1' do
  client <my_client>
  data <resource_data>               # Logical Switch options
  credentials <switches_credentials> # Specify the credentials for all the switches
  operation <op>                     # String. Used in patch action only. e.g., 'add'
  path <path>                        # String. Used in patch option only. e.g., '/scopeUris/-'
  value <val>                        # String. Used in patch option only. e.g., 'scope uri'
  scopes <scope_names>               # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:create, :create_if_missing, :delete, :refresh, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

**credentials:** Array containing Hashes indicating the credentials of the switches. They are needed for the `:create` and `:create_if_missing` actions. Each Hash should have the keys:
  - `:host` - It specifies the location switch hostname or IP address.
  - `:ssh_credentials` - User and password to access the switch through ssh.
  - `:snmp_credentials` - The switch SNMP credentials. They may vary depending on which SNMP type you are using.

:memo: NOTE: The `credentials` may also be replaced by the entire data Hash or JSON. In this case the property will be ignored.

### [oneview_datacenter](examples/datacenter.rb)

```ruby
oneview_datacenter 'Datacenter_1' do
  client <my_client>
  data <resource_data>
  racks(
    <rack1_name> => { x: <x>, y: <y>, rotation: <rotation> },
    <rack2_name> => { x: <x>, y: <y>, rotation: <rotation> },
  )
  action [:add, :add_if_missing, :remove]
end
```

### [oneview_rack](examples/rack.rb)
Available Rack actions:
  -  **add:** Add a rack to HPE OneView and updates it as necessary
  -  **add_if_missing:** Add a rack to HPE OneView if it does not exists (no updates)
  -  **add_to_rack:** Add a resource to the rack
  -  **remove:** Remove a rack from HPE OneView
  -  **remove_from_rack:** Remove a resource from a Rack

```ruby
oneview_rack 'Rack_1' do
  client <my_client>
  data <resource_data>
  action [:add, :add_if_missing, :remove]
end

oneview_rack 'Rack_1' do
  client <my_client>
  mount_options(
    name: <resource_name>,
    type: <resource_type>,
    topUSlot: 20,           # Optional. For add_to_rack only
    uHeight: 2,             # Optional. For add_to_rack only
    location: 'CenterFront' # Optional. For add_to_rack only
  )
  action [:add_to_rack, :remove_from_rack]
end
```

### [oneview_enclosure_group](examples/enclosure_group.rb)

```ruby
oneview_enclosure_group 'EnclosureGroup_1' do
  client <my_client>
  data <resource_data>
  logical_interconnect_groups ['LIG_name1', { name: 'LIG_name2', enclosureIndex: 1 }]
  script <script_string> # String. Used in set_script action only.
  action [:create, :create_if_missing, :delete, :set_script]
end
```

**logical_interconnect_groups:** Array of data used to build the interconnect bay configuration. Each item can either be a string containing the LIG name or a hash containing the LIG name and enclosureIndex. Note that the enclosureIndex is not used on API200.

### [oneview_enclosure](examples/enclosure.rb)

```ruby
oneview_enclosure 'Encl1' do
  client <my_client>
  data <resource_data>
  enclosure_group <eg_name> # String - Optional. Can also set enclosureGroupUri in data
  refresh_state <state>     # String - Optional. Used for refresh action only. Defaults to 'RefreshPending'
  options <options>         # Hash - Optional. Force options for refresh action only. Defaults to `{}`
  operation <op>            # String. Used in patch action only. e.g., 'replace'
  path <path>               # String. Used in patch option only. e.g., '/name'
  value <val>               # String. Used in patch option only. e.g., 'New Name'
  scopes <scope_names>      # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:add, :patch, :reconfigure, :refresh, :remove, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

### [oneview_drive_enclosure](examples/drive_enclosure.rb)
Note: This is a Synergy-only resource.

Performs the drive enclosure actions:
  - **hard_reset:** Hard resets the drive enclosure. Resets the drive enclosure and interrupt the active I/O.
  - **set_uid_light:** Sets the drive enclosure UID indicator (UID light) to the specified value. The String property `uid_light_state` is required, and typically assumes the "On" and "Off" values.
  - **power_state:** Sets the drive enclosure power state to the specified value. The String property `power_state` is required, and typically assumes the "On" and "Off" values.
  - **patch:** Performs a patch operation. The properties `operation`, `path` and `value` are used for this action.
  - **refresh:** Initiates a refresh process in the drive enclosure. The default refresh process ('RefreshPending') can be overrided using the `refresh_state` property.

```ruby
oneview_drive_enclosure 'DriveEnclosure1' do
  client <my_client>
  data <resource_data>
  uid_light_state <uid_light_state> # String. Required for :set_uid_light
  power_state <power_state_string>  # Required for :set_power_state
  refresh_state <refresh_state>     # Default: 'RefreshPending'. String that defines the desired refresh state in :refresh action
  operation <op>                    # String. Used in patch action only. e.g., 'replace'
  path <path>                       # String. Used in patch option only. e.g., '/name'
  value <val>                       # String, Array. Used in patch option only. e.g., 'New Name'
  action [:hard_reset, :set_uid_light, :set_power_state, :patch, :refresh]
end
```

### [oneview_volume](examples/volume.rb)

Note: if you are using API500, see the examples [here](examples/volume_api500.rb)

```ruby
oneview_volume 'Volume_1' do
  client <my_client>
  data <resource_data>
  storage_system <storage_system>
  storage_pool <storage_pool_name>
  volume_template <volume_template_name>
  snapshot_pool <snapshot_pool_name>
  properties <volume_properties>                # Hash. Used in create_from_snapshot action only. Only available on API500 and onwards.
  is_permanent <is_permanent>                   # <TrueClass, FalseClass>. Default: 'true'. Only available on API500 and onwards.
  delete_from_appliance_only <delete_from_appliance_only> # <TrueClass, FalseClass>. Default: 'false'. Used in delete action only. If true remove from appliance only, if false remove from appliance and storage system. Only available on API500 and onwards.
  action [:create, :create_if_missing, :delete, :create_from_snapshot, :add_if_missing]
end

oneview_volume 'Volume_1' do
  client <my_client>
  snapshot_data <snapshot_data>
  action [:create_snapshot, :delete_snapshot]
end
```
  - **storage_system** (String) Optional - IP address, hostname or name of the Storage System to associate with the Volume
  - **storage_pool** (String) Optional - Name of the Storage Pool from the Storage System to associate the Volume.
  - **volume_template** (String) Optional - Name of the Volume Template. If you set this, you cannot set the storage_system or storage_pool properties
  - **snapshot_pool** (String) Optional - Name of the Storage Pool containing the snapshots
  - **snapshot_data** (Hash) Required for create_snapshot & delete_snapshot - Typically includes name and description

:memo: **NOTE**: The OneView API has a provisioningParameters hash for creation, but not updates. In recipes, use same data as you would for an update, and this resource will handle creating the provisioningParameters for you if the volume needs created. (Define the desired state, not how to create it). See the [volume example](examples/volume.rb) for more on this.

### [oneview_volume_template](examples/volume_template.rb)

Note: if you are using API500, see the examples [here](examples/volume_template_api500.rb)

```ruby
oneview_volume_template 'VolumeTemplate_1' do
  client <my_client>
  data <resource_data>
  storage_system <storage_system_info>
  storage_pool <storage_pool_name>
  snapshot_pool <snapshot_pool_name>
  action [:create, :create_if_missing, :delete]
end
```

  - **storage_system** (String) Required - IP address, hostname or name of the Storage System to associate the Volume.
  - **storage_pool** (String) Required - Name of the Storage Pool from the Storage System to associate the Volume.
  - **snapshot_pool** (String) Optional - Name of the Storage Pool containing the snapshots.

 :warning: **WARNING**: The resources `oneview_volume` and `oneview_volume_template` appear to accept the same data, but they have two characteristics that differ:
 1. `oneview_volume_template` does not accept the property **volume_template**. You cannot create a volume template from another volume template.
 2. The following table maps different provisioning data keys to each type:

    oneview_volume          | oneview_volume_template   | oneview_volume_template (API500)
    ----------------------- | ------------------------- | ------------------------------------------
    :provisioningParameters | :provisioning             | properties: { provisioningType: { ... } }
    :requestedCapacity      | :capacity                 | properties: { size: { ... } }


### [oneview_storage_pool](examples/storage_pool.rb)

```ruby
oneview_storage_pool 'CPG_FC-AO' do
  client <my_client>
  storage_system <storage_system> # name or hostname
  action [:add_if_missing, :remove]
end
```

### [oneview_storage_system](examples/storage_system.rb)
Note: If you add `ip_hostname` to credentials (prior to API500) or `hostname` (API500 onwards) you don't need to specify a name to handle storage systems

```ruby
oneview_storage_system 'StorageSystem1' do
  client <my_client>
  data <storage_system_data>
  action [:add, :add_if_missing, :remove, :refresh]
end
```

### [oneview_logical_enclosure](examples/logical_enclosure.rb)

```ruby
oneview_logical_enclosure 'Encl1' do
  client <my_client>
  data <data>
  enclosures [<enclosure_names>] # Optional. Array of enclosure names (or serialNumbers or OA IPs) for :create & :create_if_missing actions only
  enclosure_group 'EncGroup1'    # Optional. Name of enclosure group for :create & :create_if_missing actions only
  script 'script'                # For :set_script action only
  dump_options(
    errorCode: <error_code>,                       # Required <String>. For :create_support_dump action only
    encrypt: <encrypt>,                            # Optional <TrueClass, FalseClass>. For :create_support_dump action only
    excludeApplianceDump: <exclude_appliance_dump> # Optional <TrueClass, FalseClass>. For :create_support_dump action only
  )
  action [:create_if_missing, :create, :update_from_group, :reconfigure, :set_script, :delete, :create_support_dump]
end
```

Notes: The default action is `:create_if_missing`. Also, the creation process may take 30min or more.

### [oneview_managed_san](examples/managed_san.rb)

```ruby
oneview_managed_san 'SAN1_0' do
  client <my_client>
  data <data>
  refresh_state <state>  # Optional <String> - Used in :refresh action. It defaults to 'RefreshPending'.
  action [:none, :refresh, :set_policy, :set_public_attributes]
end
```

### [oneview_power_device](examples/power_device.rb)

```ruby
oneview_power_device 'PowerDevice1' do
  client <my_client>
  data(
    ratedCapacity: 40
  )
  power_state [:on, :off]    # Only used with the :set_power_state action
  uid_state [:on, :off]      # Only used with the :set_uid_state action
  refresh_options <options>  # Optional <Hash> - Used in :refresh action. It defaults to { refreshState: 'RefreshPending' }.
  action [:add, :add_if_missing, :remove, :refresh, :set_power_state, :set_uid_state]
end
```

```ruby
oneview_power_device '<iPDU hostname>' do
  client <my_client>
  username <username>
  password <password>
  auto_import_certificate [true, false] # Optional. Only used with the :discover action. Default value is true.
  action :discover
end
```

### [oneview_san_manager](examples/san_manager.rb)

```ruby
oneview_san_manager '<host ip>' do
  client <my_client>
  data <data>
  action [:add, :add_if_missing, :remove]
end
```

### [oneview_scope](examples/scope.rb)
Note: Supported only in API300 onwards.

```ruby
oneview_scope 'Scope1' do
  client <my_client>
  data <resource_data>
  add <resource_list>
  remove <resource_list>
  action [:create, :create_if_missing, :delete, :change_resource_assignments]
end
```

- **add** and **remove** (Hash) Optional - Used in the `:change_resource_assignments` action only. Specify resources to be added or removed. The Hash should have `<resource_type> => [<resource_names>]` associations. The `resource_type` can be a `String` or `Symbol`, and should be in upper CamelCase (i.e., ServerHardware, Enclosure):

  ```ruby
  resource_list = {
    Enclosure: ['Encl1'],
    ServerHardware: ['Server1']
  }
  ```

  See the [example](examples/scope.rb) for more information.

### [oneview_server_hardware](examples/server_hardware.rb)

```ruby
oneview_server_hardware 'ServerHardware1' do
  client <my_client>
  data <data>
  power_state [:on, :off] # Only used with the :set_power_state action
  refresh_options <hash>  # Only used with the :refresh action. Optional
  operation <op>          # String. Used in patch action only. e.g., 'replace'
  path <path>             # String. Used in patch option only. e.g., '/name'
  value <val>             # String. Used in patch option only. e.g., 'New Name'
  scopes <scope_names>    # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:add_if_missing, :remove, :refresh, :set_power_state, :update_ilo_firmware, :patch,
          :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

### [oneview_server_hardware_type](examples/server_hardware_type.rb)

```ruby
oneview_server_hardware_type 'ServerHardwareType1' do
  client <my_client>
  data <data>
  action [:edit, :remove]
end
```

### [oneview_server_profile_template](examples/server_profile_template.rb)

```ruby
oneview_server_profile_template 'ServerProfileTemplate1' do
  client <my_client>
  data <data>
  server_hardware <server_hardware_name>
  server_hardware_type <server_hardware_type_name>
  enclosure_group <enclosure_group_name>
  enclosure <enclosure_name>
  firmware_driver <firmware_driver_name>
  ethernet_network_connections <ethernet_network_connections_data>
  fc_network_connections <fc_network_connections_data>
  network_set_connections <network_set_connections_data>
  server_profile_name <profile_name>  # String - Optional. Used in create and create_if_missing actions. It is the name of the Server Profile be used as base for the Server Profile Template. Only available on API500 and onwards to be used as base.
  os_deployment_plan <os_deployment_plan_name>
  volume_attachments <volume_attachments_data> # Array<Hash> - The volume attachments data to be created with Server Profile Template.
  action [:create, :create_if_missing, :delete]
end
```

You can specify the association of the server profile with each of the resources using the resource properties. Also it is easy to add connections using the connection properties:

- **\<resource_name\>_connections** (Array/Hash) Optional - Specify connections with the desired resource type. The Hash entry should have `<network_name> => <connection_data>` associations. The Array contains these Hash entries. See the examples for more information.
- **volume_attachments** (Array<Hash>) Optional - Specify a list of volume attachments to be created when creating or updating the Server Profile Template. See the [example](examples/server_profile_template.rb) for more information.

  To attach a Volume already created, put into the 'volume_attachments' something like:
  ```ruby
  {
    volume: 'test2', # name of existent Oneview Volume
    attachment_data: { ... } # key-pair data to be the specific attributes of the Oneview Volume Attachment
  }
  ```
  To create a new Volume and attach it, put into the 'volume_attachments' something like:
  ```ruby
    {
      volume_data: {}, # key-pair data to create a new Volume to the Oneview
      storage_system: 'ThreePAR-1', # name of Storage System associated with the Volume Attachment
      storage_pool: 'CPG-SSD', # name of Storage Pool associated with the Volume Attachment
      host_os_type: 'Windows 2012 / WS2012 R2', # the hostOsType info of San Storage
      attachment_data: { ... } # key-pair data to be the specific attributes of the Oneview Volume Attachment
    }
  ```


### [oneview_server_profile](examples/server_profile.rb)

```ruby
oneview_server_profile 'ServerProfile1' do
  client <my_client>
  data <data>
  server_profile_template <server_profile_template_name>
  server_hardware <server_hardware_name>
  server_hardware_type <server_hardware_type_name>
  enclosure_group <enclosure_group_name>
  enclosure <enclosure_name>
  firmware_driver <firmware_driver_name>
  ethernet_network_connections <ethernet_network_connections_data>
  fc_network_connections <fc_network_connections_data>
  fcoe_network_connections <fcoe_network_connections_data>
  network_set_connections <network_set_connections_data>
  os_deployment_plan <os_deployment_plan_name>
  volume_attachments <volume_attachments_data> # Array<Hash> - The volume attachments data to be created with Server Profile Template.
  action [:create, :create_if_missing, :delete]
end
```

You can specify the association of the server profile with each of the resources using the resource properties. Also it is easy to add connections using the connection properties:

- **\<network_type\>_connections** (Hash) Optional - Specify connections with the desired resource type. The Hash should have `<network_name> => <connection_data>` associations. See the [examples](examples/server_profile.rb) for more information.
- **os_deployment_plan** (String) Optional - Specify the OS Deployment Plan to be applied with the Server Profile. The OS Deployment Plan needs to be created in Image Streamer appliance in order to appear in OneView. See the [example](examples/image_streamer/server_profile_deploy.rb) for more information.
- **volume_attachments** (Array<Hash>) Optional - Specify a list of volume attachments to be created when creating or updating the Server Profile. See the [example](examples/server_profile.rb) for more information.

  To attach a Volume already created, put into the 'volume_attachments' something like:
  ```ruby
  {
    volume: 'test2', # name of existent Oneview Volume
    attachment_data: { ... } # key-pair data to be the specific attributes of the Oneview Volume Attachment
  }
  ```
  To create a new Volume and attach it, put into the 'volume_attachments' something like:
  ```ruby
    {
      volume_data: {}, # key-pair data to create a new Volume to the Oneview
      storage_system: 'ThreePAR-1', # name of Storage System associated with the Volume Attachment
      storage_pool: 'CPG-SSD', # name of Storage Pool associated with the Volume Attachment
      host_os_type: 'Windows 2012 / WS2012 R2', # the hostOsType info of San Storage
      attachment_data: { ... } # key-pair data to be the specific attributes of the Oneview Volume Attachment
    }
  ```


### [oneview_switch](examples/switch.rb)
Note: This resource is available only for the C7000 variant.

Note: API300 includes the `:patch` operation.

```ruby
oneview_switch 'Switch1' do
  client <my_client>
  data <data>
  operation <op>        # String. Used in patch action only. e.g., 'replace'
  path <path>           # String. Used in patch option only. e.g., '/name'
  value <val>           # String. Used in patch option only. e.g., 'New Name'
  scopes <scope_names>  # Array - Optional. Array of scope names. Used in add_to_scopes, remove_from_scopes or replace_scopes options only. e.g., ['Scope1', 'Scope2']
  action [:remove, :none, :patch, :add_to_scopes, :remove_from_scopes, :replace_scopes]
end
```

### [oneview_unmanaged_device](examples/unmanaged_device.rb)

```ruby
oneview_unmanaged_device 'UnmanagedDevice1' do
  client <my_client>
  data <data>
  action [:add, :add_if_missing, :remove]
end
```

### [oneview_uplink_set](examples/uplink_set.rb)

```ruby
oneview_uplink_set 'UplinkSet1' do
  client <my_client>
  data <data>
  fc_networks          # Array of assigned FC network names - Optional
  fcoe_networks        # Array of assigned FCoE network names - Optional
  networks             # Array of assigned Ethernet network names - Optional
  logical_interconnect # Name of the assigned Logical Interconnect - Optional
  native_network       # Name of the network that is designated as the native network - Optional
                       # The native network has to be added to one of the network arrays before being declared
  action [:create, :create_if_missing, :delete]
end
```

### [oneview_user](examples/user.rb)

```ruby
oneview_user 'User1' do
  client <my_client>
  data <data>
  action [:create, :create_if_missing, :delete]
end
```

### [oneview_id_pool](examples/id_pool.rb)

HPE OneView resource for managing ID pools.

```ruby
oneview_id_pool 'IDPool1' do
  client <my_client>    # Hash or OneviewSDK::ImageStreamer::Client
  pool_type <pool_type> # (Required) String - The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
  enabled <enabled>     # [TrueClass, FalseClass] - The status of the pool
  count <count>         # Integer - The quantity of IDs to allocate
  id_list <id_list>     # Array<String> - The IDs list (or IDs separeted by comma)
  action [:allocate_count, :allocate_list, :collect_ids, :update]
end
```

Performs the ID Pool actions:
  - **update:** Enable or disable an ID Pool. The Boolean property `enabled` is required.
  - **allocate_list:** Allocates one or more IDs from a according the list informed. The Array property `id_list` is required.
  - **allocate_count:** Allocates a specific amount of IDs from a pool. The Integer property `count` is required.
  - **collect_ids:** Removes one or more IDs from a pool. The Array property `id_list` is required.

### [image_streamer_artifact_bundle](examples/image_streamer/artifact_bundle.rb)
HPE Synergy Image Streamer resource for Artifact bundles.

```ruby
image_streamer_artifact_bundle 'ArtifactBundle1' do
  client <my_client>   # Hash or OneviewSDK::ImageStreamer::Client
  data <resource_data> # Hash
  deployment_plans <deployment_plan_names>
  golden_images <golden_image_names>
  os_build_plans <os_build_plan_names>
  plan_scripts <plan_script_names>
  new_name <artifact_bundle_name>          # String - The desired name for an existing artifact bundle - Optional
  file_path <local_file_path>              # String - File path for download & upload actions (Required for these actions)
  deployment_group <deployment_group_name> # String - Name of the deployment group on which to perform a backup. (Required for :backup_from_file action)
  timeout <timeout_value> # Integer - Time in seconds for the :backup_from_file action to timeout if it is not finished. - Optional
  action [:create_if_missing, :update_name, :delete, :download, :upload, :extract, :backup,
          :backup_from_file, :download_backup, :extract_backup]
end
```
- **deployment_plans**, **golden_images**, **os_build_plans** and **plan_scripts** (Array) Optional - Specify resources to be associated with the artifact bundle. The Array should contain Hashes in the following format: `{ name: <resource_name>, read_only: <true/false>} `. The `read_only` field may be ommited for resources which are read-only. See the [example](examples/image_streamer/artifact_bundle.rb) for more information.


### [image_streamer_deployment_plan](examples/image_streamer/deployment_plan.rb)
HPE Synergy Image Streamer resource for Deployment plans.

```ruby
image_streamer_deployment_plan 'DeploymentPlan1' do
  client <my_client>   # Hash or OneviewSDK::ImageStreamer::Client
  data <resource_data> # Hash
  os_build_plan <os_build_plan_name> # String - Name of the OS Build Plan to be associated to this deployment plan - Optional
  golden_image <golden_image_name> # String - Name of the Golden Image to be associated to this deployment plan - Optional
  action [:create, :create_if_missing, :delete]
end
```

### [image_streamer_golden_image](examples/image_streamer/golden_image.rb)
HPE Synergy Image Streamer resource for Golden images.

```ruby
image_streamer_golden_image 'GoldenImage1' do
  client <my_client>          # Hash or OneviewSDK::ImageStreamer::Client
  data <resource_data>        # Hash - Note: The value of data['imageCapture'] determines whether or not certain other key/value pairs are required here
  os_volume <os_volume_name>  # String - Optional - OS Volume name to associate with the resource
  os_build_plan <plan_name>   # String - Optional - OS Build Plan name to associate with the resource. The type of the OS Build Plan must match the mode (Capture or Deploy), specified in data['imageCapture']
  file_path <local_file_path> # String - File path for download or upload actions (Required in these actions)
  timeout <time_in_seconds>   # Integer - Optional - Time to timeout the request in the :download and :upload_if_missing actions. Defaults to the default resource value (Usualy 300 seconds)
  action [:create, :create_if_missing, :delete, :download, :download_details_archive, :upload_if_missing]
end
```

### [image_streamer_os_build_plan](examples/image_streamer/os_build_plan.rb)
HPE Synergy Image Streamer resource for OS Build plan.

```ruby
image_streamer_os_build_plan 'OSBuildPlan1' do
  client <my_client>   # Hash or OneviewSDK::ImageStreamer::Client
  data <resource_data> # Hash
  action [:create, :create_if_missing, :delete]
end
```

### [image_streamer_plan_script](examples/image_streamer/plan_script.rb)
HPE Synergy Image Streamer resource for Plan scripts.

```ruby
image_streamer_plan_script 'PlanScript1' do
  client <my_client>   # Hash or OneviewSDK::ImageStreamer::Client
  data <resource_data> # Hash
  action [:create, :create_if_missing, :delete]
end
```

## Examples
:information_source: There are plenty more examples in the [examples](examples) directory showing more detailed usage of each resource, but here's a few to get you started:

 - **Create an ethernet network**

  ```ruby
  my_client = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }

  eth_net_data = {
    vlanId: 50,
    purpose: 'General',
    smartLink: false,
    privateNetwork: false
  }

  oneview_ethernet_network 'Ethernet Network 1' do
    data eth_net_data
    client my_client
  end
  ```

 - **Add server hardware**

  ```ruby
  oneview_server_hardware '172.18.6.11' do
    data(
      hostname: '172.18.6.11',
      username: 'user',
      password: 'password', # Note: This should be read from a file or databag, not stored in clear text.
      licensingIntent: 'OneViewStandard',
      configurationState: 'Monitored'
    )
    client my_client
  end
  ```

 - **Add an enclosure group**

  ```ruby
  # Note: Since the script is at a separate endpoint, we can't set that here
  oneview_enclosure_group 'Enclosure-Group-1' do
    data(
      stackingMode: 'Enclosure',
      interconnectBayMappingCount: 8
    )
    client my_client
    save_resource_info true # Save all properties to a node attribute
  end
  ```

 - **Add an enclosure and associate it with the enclosure group added above**

  ```ruby
  oneview_enclosure 'Enclosure-1' do
    data lazy {{
      hostname: '172.18.1.11',
      username: 'admin',
      password: 'secret123',
      licensingIntent: 'OneView',
      enclosureGroupUri: node['oneview'][my_client.url]['Enclosure-Group-1']['uri']
    }}
    client my_client
    save_resource_info ['uri'] # Only save this to the node attributes
  end
  ```

  Note: The data hash is wrapped in a lazy block so that `node['oneview'][my_client.url]['Enclosure-Group-1']['uri']` will be set before the resource properties are parsed. However, the recommended way is to use the `enclosure_group` property, where the uri will be fetched at runtime; this just shows how you can use `lazy` with the node attributes that are saved.

 - **Delete a fibre channel network**

  ```ruby
  oneview_fc_network 'FC Network 1' do
    client my_client
    action :delete
  end
  ```

## License
This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more info.

## Contributing and feature requests
**Contributing:** You know the drill. Fork it, branch it, change it, commit it, and pull-request it.
We are passionate about improving this project, and glad to accept help to make it better. However, keep the following in mind:

 - You must sign a Contributor License Agreement first. Contact one of the authors (from Hewlett Packard Enterprise) for details and the CLA.
 - We reserve the right to reject changes that we feel do not fit the scope of this project, so for feature additions, please open an issue to discuss your ideas before doing the work.

**Feature Requests:** If you have a need that is not met by the current implementation, please let us know (via a new issue).
This feedback is crucial for us to deliver a useful product. Do not assume we have already thought of everything, because we assure you that is not the case.

## Testing
 - Style (Rubocop & Foodcritic): `$ rake style`
 - Unit: `$ rake unit`
 - Run all tests: `$ rake test`
 - Optional: Start guard to run tests automatically on file changes: `$ bundle exec guard`

 For more information please refer to the [Testing guidelines](TESTING.md).

## Authors
 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
 - Henrique Diomede - [@hdiomede](https://github.com/hdiomede)
 - Thiago Miotto - [@tmiotto](https://github.com/tmiotto)
