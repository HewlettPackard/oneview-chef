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

name             'oneview'
maintainer       'Hewlett Packard Enterprise'
maintainer_email 'chef-cookbooks@groups.ext.hpe.com'
license          'Apache v2.0'
description      'Provides OneView resources'
long_description 'Provides resources for configuring HPE OneView-managed devices'

version          '2.0.0'

source_url       'https://github.com/HewlettPackard/oneview-chef' if respond_to?(:source_url)
issues_url       'https://github.com/HewlettPackard/oneview-chef/issues' if respond_to?(:issues_url)

chef_version     '>= 12' if respond_to?(:chef_version)
depends          'compat_resource'

supports         'amazon'
supports         'arch'
supports         'centos'
supports         'debian'
supports         'fedora'
supports         'freebsd'
supports         'mac_os_x'
supports         'oracle'
supports         'redhat'
supports         'scientific'
supports         'smartos'
supports         'suse'
supports         'ubuntu'
supports         'windows'
supports         'xenserver'
