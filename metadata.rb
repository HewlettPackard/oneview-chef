name             'chef-oneview'
maintainer       'Hewlett Packard Enterprise'
maintainer_email 'jared.smartt@hpe.com'
license          'Apache v2.0'
description      'Provides OneView resources'
long_description 'Provides OneView resources'

version          '0.1.0'

source_url       'https://github.com/HewlettPackard/chef-oneview' if respond_to?(:source_url)
issues_url       'https://github.com/HewlettPackard/chef-oneview/issues' if respond_to?(:issues_url)

chef_version     '>= 12'
depends          'compat_resource'

gem              'oneview-sdk' if respond_to?(:gem)
