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

require_relative '../../resource_provider'

module OneviewCookbook
  module API200
    # StoragePool API200 provider
    class StoragePoolProvider < ResourceProvider
      def add_if_missing
        raise "Unspecified property: 'storage_system'. Please set it before attempting this action." unless @context.storage_system
        @item['poolName'] ||= @name
        sto_sys_klass = OneviewSDK.resource_named(:StorageSystem, @sdk_api_version, @sdk_api_variant)
        storage_system_resource = sto_sys_klass.new(@item.client, credentials: { ip_hostname: @context.storage_system })
        storage_system_resource = sto_sys_klass.new(@item.client, name: @context.storage_system) unless storage_system_resource.exists?
        storage_system_resource.retrieve!
        @item.set_storage_system(storage_system_resource)
        super
      end
    end
  end
end
