#
# Cookbook Name:: oneview
# Attributes:: default
#
# Copyright (C) 2016 Hewlett Packard Enterprise
#
# All rights reserved - Do Not Redistribute
#

# Set which version of the SDK to install and use:
default['oneview']['ruby_sdk_version']   = '~> 1.0'

# Save resource info to a node attribute? Possible values/types:
#  - true  : Save all info (Merged hash of OneView info and Chef resource properties)
#  - false : Do not save any info
#  - Array : ie ['uri', 'status', 'created'] Save a subset of specified attributes
default['oneview']['save_resource_info'] = ['uri']
