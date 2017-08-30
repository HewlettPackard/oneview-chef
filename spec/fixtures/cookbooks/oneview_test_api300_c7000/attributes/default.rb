#
# Cookbook Name:: oneview_test_api300_c7000
# Attributes:: default
#
# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

default['oneview']['api_version'] = 300
default['oneview']['api_variant'] = 'C7000'

default['oneview_test']['client'] = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 300 }
