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

#### enclosure_group

Enclosure group resource for HPE OneView.

```ruby
enclosure_group 'EnclosureGroup_1' do
  client <my_client>   # Hash or OneviewSDK::Client
  data <resource_data>
  action [:create, :delete]
end
```


#### oneview_ethernet_network

TODO

#### oneview_fc_network

TODO

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
