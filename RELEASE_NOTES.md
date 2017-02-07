# Release Notes
## v1.2.0
Adds the support to API300 to the existing resources and add some new resources and actions for API300.

## v1.0.0
Now the cookbook can operate with all the supported OneView 2.0 resources. It adds also some bug fixes and minor improvements.

## v0.2.0
This adds new resources, shared features and bug fixes. Also upgrades the Ruby SDK version to ~> 2.1. See the [CHANGELOG](CHANGELOG.md) for more details.

## v0.1.1
This is basically the same initial version as before, but now as Ruby SDK released a new gem with some breaking changes, we are fixing the cookbook to use version `1.0.0` of the Ruby SDK.
If desired, the version can be changed in the `/attributes/default.rb`, but doing this may result in failures in some actions for some resources.

## v0.1.0

In the future, there will be individual Chef resources for each OneView resource.
However, at this beta stage, only a subset of specific resources and a generic `oneview_resource` are available.
(The generic one will continue to exist, so don't worry about having to rewrite everything when additional resources are added.)
With the generic model, you may find that particular resources don't support certain actions or have slightly different behaviors.
Here are some known specifics for different resource types:

#### EnclosureGroup
 - Since the script is at a separate API endpoint, we can't set that here.

#### FCNetwork
 - Fails when action is `:create` and `connectionTemplateUri` is set to `nil` (because OV sets it). Leave it out instead of setting it to `nil`.

#### FCoENetwork
 - Fails when action is `:create` and `connectionTemplateUri` is set to `nil` (because OV sets it). Leave it out instead of setting it to `nil`.

#### ServerHardware
 - Requires Chef `name` parameter to be set to the hostname/IP in order to work.
 - Updates won't work because the resource doesn't support it. Use `:create_if_missing` action only
