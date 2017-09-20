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
    # ServerHardware API200 provider
    class ServerHardwareProvider < ResourceProvider
      include OneviewCookbook::RefreshActions::SetRefreshState
      def update_ilo_firmware
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        @context.converge_by "Updated iLO firmware on #{@resource_name} '#{@name}'" do
          @item.update_ilo_firmware
        end
      end

      def set_power_state
        raise "Unspecified property: 'power_state'. Please set it before attempting this action." unless @new_resource.power_state
        ps = @new_resource.power_state.to_s.downcase
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        if @item['powerState'].casecmp(ps).zero?
          Chef::Log.info("#{@resource_name} '#{@name}' is already powered #{ps}")
        else
          @context.converge_by "Power #{ps} #{@resource_name} '#{@name}'" do
            @item.public_send("power_#{ps}".to_sym)
          end
        end
      end
    end
  end
end
