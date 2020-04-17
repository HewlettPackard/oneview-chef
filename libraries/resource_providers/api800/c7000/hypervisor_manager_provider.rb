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

module OneviewCookbook
  module API800
    module C7000
      # Hypervisor Manager API800 provider
      class HypervisorManagerProvider < ResourceProvider
        def update_registration
          ret_val = false
          method2 = :update
          method1 = :create
          if @item.exists?
            @item.retrieve!
            old_name = @item.data['name']
            @item.data['name'] = @new_resource.new_name
            desired_state = Marshal.load(Marshal.dump(@item.data))
            @item.data['name'] = old_name
            if @item.like? desired_state
              Chef::Log.info("#{@resource_name} '#{@name}' is up to date")
            else
              diff = get_diff(@item, desired_state)
              Chef::Log.info "#{method2.to_s.capitalize} #{@resource_name} '#{@name}'#{diff}"
              @context.converge_by "#{method2.to_s.capitalize} #{@resource_name} '#{@name}'" do
                @item.update(desired_state)
              end
            end
          else
            @item.data['name'] = @new_resource.new_name
            create_from_update(method1)
            ret_val = true
          end
          save_res_info
          ret_val
        end

        def create_from_update(method = :create)
          Chef::Log.info "#{method.to_s.capitalize} #{@resource_name} '#{@new_resource.new_name}'"
          @context.converge_by "#{method.to_s.capitalize} #{@resource_name} '#{@new_resource.new_name}'" do
            @item.send(method)
          end
        end
      end
    end
  end
end
