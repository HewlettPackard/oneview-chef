# Cookbook for HPE OneView

[![Cookbook Version](https://img.shields.io/cookbook/v/oneview.svg)](https://supermarket.chef.io/cookbooks/oneview)

Chef cookbook that provides resources for managing OneView.

**NOTE:** This is a beta version that provides a subset of specific Chef resources and a generic `oneview_resource` Chef resource.
Additional Chef resources will be added in future releases, but the functionality of the generic resource will stay.
With the generic model, you may find that particular OneView resources don't support certain actions or have slightly different behaviors.
See [RELEASE_NOTES.md](RELEASE_NOTES.md) for more details.

## Requirements

 - Chef 12 or higher

## Usage

This cookbook is not intended to include any recipes.
Use it by creating a new cookbook and specifying a dependency on this cookbook in your metadata.

```ruby
# my_cookbook/metadata.rb
...
depends 'oneview'
```


## Attributes

 - `node['oneview']['ruby_sdk_version']` - Set which version of the SDK to install and use. Defaults to `'~> 1.0'`
 - `node['oneview']['save_resource_info']` - Save resource info to a node attribute? Defaults to `['uri']`. Possible values/types:
   - `true` - Save all info (Merged hash of OneView info and Chef resource properties). Warning: Resource credentials will be saved if specified.
   - `false` - Do not save any info
   - `Array` - ie `['uri', 'status', 'created_at']` Save a subset of specified attributes

See [attributes/default.rb](attributes/default.rb) for more info.

## Resources

### Resource Parameters

The following are the standard parameters available for all resources. Some resources have additional parameters or small differences; see their doc sections below for more details.

 - **client**: Hash or OneviewSDK::Client object that contains information about how to connect to the OneView instance. Required attributes are: `url`, `user`, and `password`. See [this](https://github.com/HewlettPackard/oneview-sdk-ruby#configuration) for more options.
 - **data**: Hash specifying options for this resource. Refer to the OneView API docs for what's available and/or required. If no name attribute is given, it will use the name given to the Chef resource.
   - In addition to the API docs, you can use the [oneview-sdk gem's CLI](https://github.com/HewlettPackard/oneview-sdk-ruby#cli) to quickly show information about resources. If you're wanting to know which data properties exist for a resource, it might make sense to create a resource on the Web UI, then view the data. For example, after creating a new ethernet network named `eth1`, run `$ oneview-sdk-ruby show EthernetNetwork eth1`
 - **action**: Symbol specifying what to do with this resource. Options for most resources (**some may differ**):
   - `:create` - (Default) Ensure this resource exists and matches the data given.
   - `:create_if_missing` - Ensure this resource exists, but don't ensure it is up to date on subsequent chef-client runs.
   - `:delete` - Delete this resource from OneView. For this, you only need to specify the resource name or uri in the data section.
 - **save_resource_info**: (See the `node['oneview']['save_resource_info']` attribute above.) Defaults to `node['oneview']['save_resource_info']`. Doesn't apply to the `:delete` action
   - Once the resource is created, you can access this data at `node['oneview'][<oneview_url>][<resource_name>]`. This can be useful to extract URIs from other resources, etc.

### oneview_resource

This is a generic provider for managing any OneView resource.
This really exists only for resources that don't have a specific provider; if a specific one exists, please use it instead
(See [RELEASE_NOTES.md](RELEASE_NOTES.md)).

The basic usage is as follows:

```ruby
oneview_resource '' do
  client <my_client>   # Hash or OneviewSDK::Client
  type <resource_type> # String or Symbol
  data <resource_data> # Hash
  action [:create, :create_if_missing, :delete] # (Choose only 1)
end
```

**type:** String or Symbol corresponding to the name of the resource type. For example, `EthernetNetwork`, `Enclosure`, `Volume` etc. These should line up with the OneView SDK resource classes listed [here](https://github.com/HewlettPackard/oneview-sdk-ruby/tree/master/lib/oneview-sdk/resource).

### oneview_ethernet_network

Ethernet network resource for HPE OneView.

```Ruby
oneview_ethernet_network 'Eth1' do
  client <my_client>
  data <resource_data>
  action [:create, :create_if_missing, :delete]
end
```

### oneview_fc_network

FC network resource for HPE OneView.

```Ruby
oneview_fc_network 'Fc1' do
  client <my_client>
  data <resource_data>
  action [:create, :create_if_missing, :delete]
end
```


### oneview_fc_network

FCoE network resource for HPE OneView.

```Ruby
oneview_fcoe_network 'FCoE1' do
  client <my_client>
  data <resource_data>
  action [:create, :create_if_missing, :delete]
end
```

### oneview_firmware

Firmware bundle and driver resource for HPE OneView.

```Ruby
oneview_firmware '/full/path/to/file.iso'  do
  client <my_client>
  action [:add, :remove]
end

oneview_firmware 'firmware_bundle_name'  do
  client <my_client>
  action :remove
end
```

```Ruby
oneview_firmware 'CustomSPP'  do
  client <my_client>
  spp_name 'SPPName'
  hotfixes_names [
    'hotfix1_name'
  ]
  action :create_custom_spp
end
```

### oneview_interconnect

Interconnect resource for HPE OneView.

Perform the Interconnect actions:
  - **reset:** Resets the Interconnect.
  - **reset_port_protection:** Resets the Interconnect port protection.
  - **update_port:** Updates one specified port in the Interconnect. The Hash property `port_options` is required, and is also needed to specify the key `"name"` corresponding to the port name. (E.G.: "X1", "Q1.1")
  - **set_uid_light:** Sets the Interconnect UID indicator (UID light) to the specified value. The String property `uid_light_state` is required, and typically assumes the "On" and "Off" values.
  - **power_state:** Sets the Interconnect power state to the specified value. The String property `power_state` is required, and typically assumes the "On" and "Off" values.

```Ruby
oneview_interconnect 'Interconnect1' do
  client <my_client>
  data <resource_data>
  port_options <port_data_hash> # Required for :update_port
  uid_light_state <uid_light_state_string> # Required for :set_uid_light
  power_state <power_state_string> # Required for :set_power_state
  action [:reset, :reset_port_protection, :update_port, :set_uid_light, :set_power_state]
end
```

### oneview_logical_interconnect_group

Logical Interconnect Group resource for HPE OneView.

It provides the creation in three different levels:
 1. The base one where you just specify the name and some configuration parameters.
 2. Next one where you specify the interconnect types with the corresponding bays.
 3. The most complete way, where you can also specify the uplink sets for your group. (It is also possible to add and edit them later using the `oneview_uplink_set` resource)

The `:create` action will always update the Logical Interconnect Group if you use the creation modes 2 and 3. So if you want to avoid this, use the action `:create_if_missing`

```ruby
oneview_logical_interconnect_group 'LogicalInterconnectGroup_1' do
  client <my_client>
  data <resource_data>
  interconnects <interconnect_map> # Array specifying the interconnects in the bays
  uplink_sets <uplink_set_map> # Array containing information
  action [:create, :create_if_missing, :delete]
end
```


**interconnects:** Array containing a list of Hashes indicating whether the interconnects are and which type they correspond to. Each hash should contain the keys:
  - `:bay` - It specifies the location (bay) where this interconnect is attached to. The value should range from 1 to 8.
  - `:type` - The interconnect type name that is currently attached to your enclosure.

```ruby
interconnects_data = [
  {bay: 1, type: 'HP VC FlexFabric 10Gb/24-Port Module'},
  {bay: 2, type: 'HP VC FlexFabric 10Gb/24-Port Module'}
]
```

**uplink_sets:** Array containing a list of Hashes describing each uplink set that should be present in the group. Each hash should contain the keys:
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

  - `:connections` - An Array of Hashes containing the association of bay and the port name. The Hashes keys are:
    - `:bay` - Number of the bay the interconnect is attached to identify in which interconnect the uplink will be created.
    - `:port` - The name of the port of the interconnect. It may change depending on the interconnect type.

    ```ruby
    uplink_connections = [
      {bay: 1, port: 'X5'},
      {bay: 2, port: 'X7'}
    ]
    ```

  - `:networks` - An array containing the names of the networks with the associated Uplink set. The networks should be created prior to the execution of this resource. Remember to match Ethernet networks for Ethernet Uplink sets, and one FC Network for FibreChannel Uplink sets.

  At the end we may have an Hash like this to be used in the attribute:

  ```ruby
  uplink_set_definitions = [
    { data: uplink_data_1,  connections: connections_1, networks: ['Ethernet_1', 'Ethernet_2']},
    { data: uplink_data_2,  connections: connections_2, networks: ['FC_1']}
  ]
  ```

### oneview_logical_switch_group

Logical Switch Group resource for HPE OneView.

```ruby
oneview_logical_switch_group 'LogicalSwitchGroup_1' do
  client <my_client>
  data <resource_data> # Switch options
  switch_number <number> # Specify how many switches are in the group
  switch_type <switch_type_name> # Specify the type of the switches for the entire group
  action [:create, :create_if_missing, :delete]
end
```

The `:create` and `create_if_missing` can be done in two different ways:
  1. By specifying the 'switchMapTemplate' attribute in the `data` property
  2. By specifying both `switch_number` and `switch_type` properties, but no 'switchMapTemplate' attribute in the `data` property

:memo: **Note:** You are still able to specify the `switch_number` and `switch_type` properties even if you use the 'switchMapTemplate' attribute, but they will be **ignored**, only the values from 'switchMapTemplate' are going to be used.

### oneview_logical_switch

Logical switch resource for HPE OneView.

```ruby
oneview_logical_switch 'LogicalSwitch_1' do
  client <my_client>
  data <resource_data> # Logical Switch options
  credentials <switches_credentials> # Specify the credentials for all the switches
  action [:create, :create_if_missing, :delete, :refresh]
end
```

**credentials:** Array containing Hashes indicating the credentials of the switches. They are needed for the `:create` and `:create_if_missing` actions. Each Hash should have the keys:
  - `:host` - It specifies the location switch hostname or IP address.
  - `:ssh_credentials` - User and password to access the switch through ssh.
  - `:snmp_credentials` - The switch SNMP credentials. They may vary depending on which SNMP type you are using.

:memo: NOTE: The `credentials` may also be replaced by the entire data Hash or JSON. In this case the property will be ignored.

### oneview_datacenter

Datacenter resource for HPE OneView.

```ruby
oneview_datacenter 'Datacenter_1' do
  client <my_client>
  data <resource_data>
  racks(
    <rack1_name> => {<x>, <y>, <rotation>},
    <rack2_name> => {<x>, <y>, <rotation>},
  )
  action [:add, :add_if_missing, :remove]
end
```

### oneview_rack

Rack resource for HPE OneView.

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

### oneview_enclosure_group

Enclosure Group resource for HPE OneView.

```ruby
oneview_enclosure_group 'EnclosureGroup_1' do
  client <my_client>
  data <resource_data>
  logical_interconnect_group <LIG_name>
  action [:create, :create_if_missing, :delete]
end
```

### oneview_enclosure

Enclosure resource for HPE OneView.

```ruby
oneview_enclosure 'Encl1' do
  client <my_client>
  data <resource_data>
  enclosure_group <enclosure_group_name> # String - Optional. Can also set enclosureGroupUri in data
  action [:add, :remove]
end
```

### oneview_volume

Volume resource for HPE OneView.

```ruby
oneview_volume 'Volume_1' do
  client <my_client>
  data <resource_data>
  storage_system_name <storage_system_name>
  storage_system_ip <storage_system_ip>
  storage_pool <storage_pool_name>
  volume_template <volume_template_name>
  snapshot_pool <snapshot_pool_name>
  action [:create, :create_if_missing, :delete]
end
```
  - **storage_system_name** (String) Optional - Name of the Storage System to associate the Volume.
  - **storage_system_ip** (String) Optional - IP address or hostname of the Storage System to associate the Volume.
  - **storage_pool** (String) Optional - Name of the Storage Pool from the Storage System to associate the Volume.
  - **volume_template** (String) Optional - Name of the Volume Template.
  - **snapshot_pool** (String) Optional - Name of the Storage Pool containing the snapshots.

:memo: **NOTE**: Only one of `storage_system_name` and `storage_system_ip` need to be provided. If both are specified at once, the `storage_system_ip` prevails, then ignoring the `storage_system_name` value.

:memo: **NOTE**: The OneView API has a provisioningParameters hash for creation, but not updates. In recipes, use same data as you would for an update, and this resource will handle creating the provisioningParameters for you if the volume needs created. (Define the desired state, not how to create it). See the [volume example](examples/volume.rb) for more on this.

### oneview_volume_template

Volume Template resource for HPE OneView.

```ruby
oneview_volume_template 'VolumeTemplate_1' do
  client <my_client>
  data <resource_data>
  storage_system_name <storage_system_name>
  storage_system_ip <storage_system_ip>
  storage_pool <storage_pool_name>
  snapshot_pool <snapshot_pool_name>
  action [:create, :create_if_missing, :delete]
end
```
  - **storage_system_name** (String) Optional - Name of the Storage System to associate the Volume.
  - **storage_system_ip** (String) Optional - IP address or hostname of the Storage System to associate the Volume.
  - **storage_pool** (String) Optional - Name of the Storage Pool from the Storage System to associate the Volume.
  - **snapshot_pool** (String) Optional - Name of the Storage Pool containing the snapshots.

 :memo: **NOTE**: Only one of `storage_system_name` and `storage_system_ip` need to be provided. If both are specified at once, the `storage_system_ip` prevails, then ignoring `storage_system_name` value.

 :warning: **WARNING**: The resources `oneview_volume` and `oneview_volume_template` appear to accept the same data, but they have two characteristics that differ:
 1. `oneview_volume_template` does not accepts the property **volume_template**. In other means, you cannot create a Volume template from another Volume template.
 2. The following provisioning data keys are different:

    oneview_volume          | oneview_volume_template
    ----------------------- | -------------------------
    :provisioningParameters | :provisioning
    :requestedCapacity      | :capacity


### oneview_storage_pool

Storage pool resource for HPE OneView.

```ruby
oneview_storage_pool 'CPG_FC-AO' do
  client <my_client>
  storage_system <storage_system> # name or hostname
  action [:add_if_missing, :remove]
end
```

### oneview_storage_system

Storage system resource for HPE OneView.

If you add ip_hostname to credentials you don't need to specify a name to
handle storage systems

```ruby
storage_system_credentials = {
  'ip_hostname' => '<ip_hostname>',
  'username' => 'user',
  'password' => 'password'
}

oneview_storage_system 'ThreePAR7200-8147' do
  client <my_client>
  data(
    credentials: storage_system_credentials,
    managedDomain: 'TestDomain'
  )
  action [:add, :add_if_missing, :remove]
end
```

```ruby
oneview_storage_system 'ThreePAR7200-81471' do
  client my_client
  data(
    ip_hostname: '127.0.0.1',
    username: 'username',
    password: 'password'
  )
  action :edit_credentials
end

### oneview_logical_enclosure

Logical enclosure resource for HPE OneView.

```ruby
oneview_logical_enclosure 'Encl1' do
  client <my_client>
  action :update_from_group
end
```

### oneview_power_device

Power device resource for HPE OneView.

```ruby
oneview_power_device 'PowerDevice1' do
  client <my_client>
  data(
    ratedCapacity: 40
  )
  action [:add, :add_if_missing, :remove]
end
```

```ruby
oneview_power_device '<iPDU hostname>' do
  client <my_client>
  username <username>
  password <password>
  action :discover
end
```

### oneview_server_hardware

Server hardware resource for HPE OneView

```ruby
oneview_server_hardware 'ServerHardware1' do
  client <my_client>
  data <data>
  power_state [:on, :off] # Only used with the :set_power_state action
  refresh_options <hash>  # Only used with the :refresh action. Optional
  action [:add_if_missing, :remove, :refresh, :set_power_state, :update_ilo_firmware]
end
```

### oneview_switch

Switch resource for HPE OneView

```ruby
oneview_switch 'Switch1' do
  client <my_client>
  data <data>
  action [:remove, :none]
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
  # Notes:
  #  - It can't be updated, so we use the default :add_if_missing action here
  #  - Also, because the hostname is used as a name in OneView, we need to set the name to the hostname
  oneview_server_hardware '172.18.6.11' do
    data(
      hostname: '172.18.6.4',
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
  # Notes:
  #  - Since the script is at a separate endpoint, we can't set that here
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

  Note: The data hash is wrapped in a lazy block so that `node['oneview'][my_client.url]['Enclosure-Group-1']['uri']` will be set before the resource parameters are parsed. However, the recommended way is to use the `enclosure_group` (name) parameter, where the uri will be fetched at runtime; this just shows how you can use `lazy` with the node attributes that are saved.

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

## Authors

 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
 - Henrique Diomede - [@hdiomede](https://github.com/hdiomede)
 - Thiago Miotto - [@tmiotto](https://github.com/tmiotto)
