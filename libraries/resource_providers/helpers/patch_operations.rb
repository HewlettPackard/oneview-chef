# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewCookbook
  # Module for Patch operations used by many resources
  module PatchOperations
    # module for patch operations that replace On/Off values
    module OnOff
      def on_off_handler(property_name, item_attribute_name, operation_path)
        raise "Unspecified property: '#{property_name}'. Please set it before attempting this action." unless @new_resource.send(property_name)
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        op_value = @new_resource.send(property_name).capitalize
        if @item[item_attribute_name] != @new_resource.send(property_name)
          @context.converge_by "#{item_attribute_name} of #{@resource_name} '#{@name}' replaced to #{op_value}" do
            @item.patch('replace', operation_path, op_value)
          end
        else
          Chef::Log.info("'#{item_attribute_name}' of #{@resource_name} '#{@name}' is already #{op_value}")
        end
      end

      def set_uid_light
        on_off_handler(:uid_light_state, 'uidState', '/uidState')
      end

      def set_power_state
        on_off_handler(:power_state, 'powerState', '/powerState')
      end
    end

    # module for reset operations that replace Reset value
    module Reset
      def reset_handler(path)
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        # Nothing to verify
        @context.converge_by "#{path.delete('/').gsub(/([A-Z])/, ' \1').capitalize} #{@resource_name} '#{@name}'" do
          @item.patch('replace', path, 'Reset')
        end
      end

      def reset
        reset_handler('/softResetState')
      end

      def hard_reset
        reset_handler('/hardResetState')
      end
    end
  end
end
