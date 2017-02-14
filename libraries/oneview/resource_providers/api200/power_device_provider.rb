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

require_relative '../../../resource_provider'

module OneviewCookbook
  module API200
    # PowerDevice API200 provider
    class PowerDeviceProvider < ResourceProvider
      def discover
        pd_klass = resource_named(:PowerDevice)
        power_devices_list = pd_klass.get_ipdu_devices(@item.client, @name)
        if power_devices_list.empty?
          Chef::Log.info "Discovering #{@resource_name} '#{@name}'"
          @context.converge_by "Discovered #{@resource_name} '#{@name}'" do
            pd_klass.discover(@item.client, hostname: @name, username: @context.username, password: @context.password)
          end
        else
          Chef::Log.info("#{@resource_name} '#{@name}' is up to date")
        end
      end

      def remove
        # First try to remove by name, if it does not work it consider the power device is an iPDU
        return true if super
        power_devices_list = resource_named(:PowerDevice).get_ipdu_devices(@item.client, @name)
        return false if power_devices_list.empty?
        @item = power_devices_list.first
        super
      end
    end
  end
end
