# Release Notes

## v0.1.0

In the future, there will be individual Chef resources for each OneView resource.
However, at this beta stage, only a few specific resources and a generic `oneview_resource` is available.
(The generic one will continue to exist, so don't worry about having to rewrite everything when additional resources are added.)
With the generic model, you may find that particular resources don't support certain actions or have slightly different behaviors.
Here are some known specifics for different resource types:

#### EnclosureGroup
 - Since the script is at a seperate API endpoint, we can't set that here.

#### FCNetwork
 - Fails when action is `:create` and `connectionTemplateUri` is set to `nil` (because OV sets it). Leave it out instead of setting it to `nil`.

#### FCoENetwork
 - Fails when action is `:create` and `connectionTemplateUri` is set to `nil` (because OV sets it). Leave it out instead of setting it to `nil`.

#### ServerHardware
 - Requires Chef `name` parameter to be set to the hostname/IP in order to work.
 - Updates won't work because the resource doesn't support it. Use `:create_if_missing` action only
