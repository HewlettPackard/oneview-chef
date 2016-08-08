# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# Set which version of the SDK to install and use:
# Warning: Changing the SDK version may cause issues within the Cookbook
# Edit only if you know exactly what are you doing
default['oneview']['ruby_sdk_version'] = '"~> 2.0'

# Save resource info to a node attribute? Possible values/types:
#  - true  : Save all info (Merged hash of OneView info and Chef resource properties)
#  - false : Do not save any info
#  - Array : ie ['uri', 'status', 'created'] Save a subset of specified attributes
default['oneview']['save_resource_info'] = ['uri']
