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

module OneviewCookbook
  module API300
    module Synergy
      # Fabric API300 Synergy provider
      class FabricProvider < ResourceProvider
        def set_reserved_vlan_range
          @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
          options = { 'reservedVlanRange' => convert_keys(@new_resource.reserved_vlan_range, :to_s) }
          options['reservedVlanRange']['type'] ||= 'vlan-pool'
          if @item.like? options
            Chef::Log.info("#{resource_name} '#{name}' reserved Vlan range is up to date")
          else
            diff = get_diff(@item, options)
            Chef::Log.info "Setting #{resource_name} '#{name}' reserved Vlan range#{diff}"
            Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
            Chef::Log.debug "Current state: #{JSON.pretty_generate(@item['reservedVlanRange'])}"
            Chef::Log.debug "Desired state: #{JSON.pretty_generate(options['reservedVlanRange'])}"
            @context.converge_by "Set reserved Vlan range for #{resource_name} '#{name}'" do
              @item.set_reserved_vlan_range(options['reservedVlanRange'])
            end
          end
        end
      end
    end
  end
end
