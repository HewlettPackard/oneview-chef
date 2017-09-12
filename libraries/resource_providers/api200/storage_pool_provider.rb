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

module OneviewCookbook
  module API200
    # StoragePool API200 provider
    class StoragePoolProvider < ResourceProvider
      def load_storage_system
        raise "Unspecified property: 'storage_system'. Please set it before attempting this action." unless @new_resource.storage_system
        @item['poolName'] ||= @name
        data = {
          credentials: { ip_hostname: @new_resource.storage_system },
          name: @new_resource.storage_system
        }
        @item.set_storage_system(load_resource(:StorageSystem, data))
      end

      def add_if_missing
        load_storage_system
        super
      end

      def remove
        load_storage_system
        super
      end
    end
  end
end
