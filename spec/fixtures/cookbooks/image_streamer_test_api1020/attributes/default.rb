#
# Cookbook Name:: image_streamer_test_api1020
# Attributes:: default
#
# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
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

default['oneview']['api_version'] = 1020

default['image_streamer_test']['client'] = { url: 'https://imagestreamer.example.com', token: 'token123', api_version: 1020 }
