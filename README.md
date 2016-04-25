# Cookbook for HPE OneView

Chef cookbook that provides resources for managing OneView.

## Requirements

 - Chef 12 or higher

## Usage

This cookbook is not intended to include any recipes.
Use it by creating a new cookbook and specifying a dependency on this cookbook.

```ruby
# my_cookbook/metadata.rb
...
depends 'oneview'
```

## Resources

This cookbook exposes a single `oneview_resource` provider for managing any OneView resource. The basic usage is as follows:

```ruby
oneview_resource '' do
  client <my_client>   # Hash or OneviewSDK::Client
  type <resource_type>
  options <resource_options>
  action [:create, :create_only, :delete]
end
```

### Parameters

 - **client**: Hash or OneviewSDK::Client object that contains information about how to connect to the OneView instance. Required attributes are: `url`, `user`, and `password`.
 - **type**: String or Symbol corresponding to the name of the resource type. For example, `EthernetNetwork`, `Enclosure`, `Volume` etc. These should line up with the OneView SDK resource classes listed [here](https://github.hpe.com/Rainforest/oneview-sdk-ruby/tree/master/lib/oneview-sdk/resource).
 - **options**: Hash specifying options for this resource. Refer to the OneView API docs for what's available and/or required. If no name attribute is given, it will use the name given to the Chef resource.
 - **action**: Symbol specifying what to do with this resource. Options:
   - `:create` - (Default) Ensure this resource exists and matches the options given.
   - `:create_only` - Ensure this resource exists, but don't ensure it is up to date on subsequent chef-client runs.
   - `:delete` - Delete this resource from OneView. For this, you only need to specify the resource name or uri in the options section.

### Examples

 - **Create an ethernet network**
 
  ```ruby
  my_client = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }

  eth_net_options = {
    vlanId: 50,
    purpose: 'General',
    smartLink: false,
    privateNetwork: false
  }
  
  oneview_resource 'Ethernet Network 1' do
    client my_client
    options eth_net_options
    type :EthernetNetwork
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


## Authors

 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
