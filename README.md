# Cookbook for HPE OneView

Chef cookbook that provides resources for managing OneView.

**NOTE:** This is a beta version that provides a few specific Chef resources and a generic `oneview_resource` Chef resource.
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

#### oneview_resource

This is a generic provider for managing any OneView resource.
The basic usage is as follows:

```ruby
oneview_resource '' do
  client <my_client>   # Hash or OneviewSDK::Client
  type <resource_type>
  data <resource_data>
  action [:create, :create_if_missing, :delete]
end
```



#### oneview_ethernet_network

Ethernet network resource for HPE OneView.

```Ruby
oneview_ethernet_network 'Eth1' do
  data <resource_data>
  client <my_client>
  action [:create, :create_if_missing, :delete]
end
```

#### oneview_fc_network

FC network resource for HPE OneView.

```Ruby
oneview_fc_network 'Fc1' do
  data <resource_data>
  client <my_client>
  action [:create, :create_if_missing, :delete]
end
```

#### oneview_logical_interconnect_group

Logical Interconnect Group resource for HPE OneView.

It provides the creation in three different levels:
 1. The base one where you just specify the name and some configuration parameters.
 2. Next one where you specify the interconnect types with the corresponding bays.
 3. The most complete way, where you can also specify the uplink sets for your group. (It is also possible to add and edit them later using the `oneview_uplink_set` resource)

The `:create` action will always update the Logical Interconnect Group if you use the creation modes 2 and 3. So if you want to avoid this, use the action `:create_if_missing`

```ruby
oneview_logical_interconnect_group 'LogicalInterconnectGroup_1' do
  client <my_client>   # Hash or OneviewSDK::Client
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

#### oneview_enclosure_group

Enclosure Group resource for HPE OneView.

```ruby
oneview_enclosure_group 'EnclosureGroup_1' do
  client <my_client>   # Hash or OneviewSDK::Client
  data <resource_data>
  action [:create, :delete]
end
```

#### oneview_enclosure

Enclosure resource for HPE OneView.

```ruby
oneview_enclosure 'Encl1' do
  data <resource_data>
  enclosure_group <enclosure_group_name>
  client client
  action [:add, :remove]
end
```

#### oneview_volume

Volume resource for HPE OneView.

```ruby
oneview_volume 'Volume_1' do
  client <my_client>   # Hash or OneviewSDK::Client
  data <resource_data>
  storage_system_name <storage_system_name>
  storage_system_ip <storage_system_ip>
  storage_pool <storage_pool_name>
  volume_template <volume_template_name>
  snapshot_pool <snapshot_pool_name>
  action [:create, :create_if_missing, :delete]
end
```
  - **storage_system_name**: Optional - Name of the Storage System to associate the Volume.
  - **storage_system_ip**: Optional - IP address or hostname of the Storage System to associate the Volume.
  - **storage_pool**: Optional - Name of the Storage Pool from the Storage System to associate the Volume.
  - **volume_template**: Optional - Name of the Volume Template.
  - **snapshot_pool**: Optional - Name of the Storage Pool containing the snapshots.

:memo: **NOTE**: Only one of `storage_system_name` and `storage_system_ip` need to be provided. If both are specified at once, the `storage_system_ip` prevails, then ignoring `storage_system_name` value.

#### oneview_volume_template

Volume Template resource for HPE OneView.

```ruby
oneview_volume_template 'VolumeTemplate_1' do
  client <my_client>   # Hash or OneviewSDK::Client
  data <resource_data>
  storage_system_name <storage_system_name>
  storage_system_ip <storage_system_ip>
  storage_pool <storage_pool_name>
  snapshot_pool <snapshot_pool_name>
  action [:create, :create_if_missing, :delete]
end
```
  - **storage_system_name**: Optional - Name of the Storage System to associate the Volume.
  - **storage_system_ip**: Optional - IP address or hostname of the Storage System to associate the Volume.
  - **storage_pool**: Optional - Name of the Storage Pool from the Storage System to associate the Volume.
  - **snapshot_pool**: Optional - Name of the Storage Pool containing the snapshots.

 :memo: **NOTE**: Only one of `storage_system_name` and `storage_system_ip` need to be provided. If both are specified at once, the `storage_system_ip` prevails, then ignoring `storage_system_name` value.

 :warning: **WARNING**: The resources `oneview_volume` and `oneview_volume_template` appear to accept the same data, but they have two characteristics that differ:
 1. `oneview_volume_template` does not accepts the property **volume_template**. In other means, you cannot create a Volume template from another Volume template.
 2. The provisioning data keys are different:

oneview_volume        |  oneview_volume_template
------------------------- | -------------------------
:provisioningParameters   |       :provisioning
:requestedCapacity      |         :capacity
:shareable          |         :shareable
:provisionType        |       :provisionType



#### oneview_storage_pool

Storage pool resource for HPE OneView.

```ruby
oneview_storage_pool 'CPG_FC-AO' do
  client <my_client>   # Hash or OneviewSDK::Client
  storage_system_name <storage_system_name>
  action [:add, :remove]
end
```

#### oneview_storage_system

Storage system resource for HPE OneView.

If you add ip_hostname to credentials you don't need to specify a name to
handle storage systems

```ruby
storage_system_credentials = {
  ip_hostname: '<ip_hostname>',
  username: 'user',
  password: 'password'
}

oneview_storage_system 'ThreePAR7200-8147' do
  data ({
    credentials:storage_system_credentials,
    managedDomain: 'TestDomain'
  })
  client client
  action [:add, :edit, :delete]
end
```

#### oneview_logical_enclosure

Logical enclosure resource for HPE OneView.

```ruby
oneview_logical_enclosure 'Encl1' do
  client client
  action :update_from_group
end
```

### Parameters

 - **client**: Hash or OneviewSDK::Client object that contains information about how to connect to the OneView instance. Required attributes are: `url`, `user`, and `password`.
 - **type**: (For generic `oneview_resource` only) String or Symbol corresponding to the name of the resource type. For example, `EthernetNetwork`, `Enclosure`, `Volume` etc. These should line up with the OneView SDK resource classes listed [here](https://github.hpe.com/Rainforest/oneview-sdk-ruby/tree/master/lib/oneview-sdk/resource).
 - **data**: Hash specifying options for this resource. Refer to the OneView API docs for what's available and/or required. If no name attribute is given, it will use the name given to the Chef resource.
 - **action**: Symbol specifying what to do with this resource. Options:
   - `:create` - (Default) Ensure this resource exists and matches the data given.
   - `:create_if_missing` - Ensure this resource exists, but don't ensure it is up to date on subsequent chef-client runs.
   - `:delete` - Delete this resource from OneView. For this, you only need to specify the resource name or uri in the data section.
 - **save_resource_info**: (See the `node['oneview']['save_resource_info']` attribute above.) Defaults to `node['oneview']['save_resource_info']`. Doesn't apply to the `:delete` action
   - Once the resource is created, you can access this data at `node['oneview']['resources'][<resource_name>]`. This can be useful to extract URIs from other resources, etc.

### Examples

 - **Create an ethernet network**

  ```ruby
  my_client = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }

  eth_net_data = {
    vlanId: 50,
    purpose: 'General',
    smartLink: false,
    privateNetwork: false
  }

  oneview_resource 'Ethernet Network 1' do
    type :EthernetNetwork
    data eth_net_data
    client my_client
  end
  ```

 - **Add server hardware**

  ```ruby
  # Notes:
  #  - It can't be updated, so we use the :create_if_missing action here
  #  - Also, because the hostname is used as a name in OneView, we need to set the name to the hostname
  oneview_resource '172.18.6.11' do
    type :ServerHardware
    data(
      hostname: '172.18.6.11',
      username: 'admin',
      password: 'secret123', # Note: This should be read from a file or databag, not stored in clear text.
      licensingIntent: 'OneView'
    )
    client my_client
    action :create_if_missing
  end
  ```

 - **Add an enclosure group**

  ```ruby
  # Notes:
  #  - Since the script is at a seperate endpoint, we can't set that here
  oneview_resource 'Enclosure-Group-1' do
    type :EnclosureGroup
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
  oneview_resource 'Enclosure-1' do
    type :Enclosure
    data lazy {{
      hostname: '172.18.1.11',
      username: 'admin',
      password: 'secret123',
      licensingIntent: 'OneView',
      enclosureGroupUri: node['oneview']['resources']['Enclosure-Group-1']['uri']
    }}
    client my_client
    save_resource_info ['uri'] # Only save this to the node attributes
  end
  ```

 - **Delete a fibre channel network**

  ```ruby
  oneview_resource 'FC Network 1' do
    client my_client
    type :FCNetwork
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

### Testing

 - Rubocop: `$ rake rubocop`
 - Foodcritic: `$ rake foodcritic`
 - Run all tests: `$ rake test`

## Authors

 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
