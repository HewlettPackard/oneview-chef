# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# Set which version of the SDK to install and use:
# Warning: Changing the SDK version may cause issues within the Cookbook
# Edit only if you know exactly what are you doing
default['oneview']['ruby_sdk_version'] = '~> 5.0'

# Save resource info to a node attribute? Possible values/types:
#  - true  : Save all info (Merged hash of OneView info and Chef resource properties)
#  - false : Do not save any info
#  - Array : ie ['uri', 'status', 'created'] Save a subset of specified attributes
default['oneview']['save_resource_info'] = ['uri']

# When looking for a matching Chef resource provider class, this version will be the default.
# This default value will be overriden if the the property `api_version` is defined or if the client parameter `api_version`
#   is specified (If the client is a OneviewSDK object, by default it has this parameter defined)
# A resource provider must be defined for this version. For example, when set to 200, it will look
# for the resource in OneviewCookbook::API200. When 300, it will look in OneviewCookbook::API300
# See the libraries/resources directory for more info on supported API versions
default['oneview']['api_version'] = 200

# When looking for a matching Chef resource provider class, this variant will be used by default
# For example, when the api_version attribute described above is set to 300 and the api_variant
# set to C7000, it will look for the resource in OneviewCookbook::API300::C7000
# Note: If there is only 1 variant for the API module (e.g., API200), this attribute doesn't matter.
# See the libraries/resources directory for more info on supported API versions and variants.
# At the time of writing this, the following api_version & api_variant combinations are supported:
#   api_version 200: No variants exist, so don't worry about setting the api_variant attribute
#   api_version 300: ['C7000', 'Synergy']
default['oneview']['api_variant'] = 'C7000'
# default['oneview']['api_variant'] = 'Synergy'
