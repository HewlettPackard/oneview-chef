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
  module API300
    module Synergy
      # Helper module containing methods for loading OS Deployment Plans into @item
      module ServerProfileHelpers
        def load_os_deployment_plan
          # Return if the property is not defined
          return unless @new_resource.os_deployment_plan
          @item['osDeploymentSettings'] ||= {}
          # Return if the value is already defined in data
          if @item['osDeploymentSettings']['osDeploymentPlanUri']
            return Chef::Log.warn('The OS deployment plan is already defined in `data`. ' \
               "The `os_deployment_plan` property will be ignored in favor of '#{@item['osDeploymentSettings']['osDeploymentPlanUri']}'")
          end
          # Get the user specified custom attributes
          custom = @item['osDeploymentSettings']['customAttributes'] || @item['osDeploymentSettings']['osCustomAttributes']
          # Loads the OS deployment plan and gets the default custom attributes
          plan = load_resource(:OSDeploymentPlan, @new_resource.os_deployment_plan)
          plan_defaults = plan['additionalParameters']
          # Merge both user defined and default custom attributes
          custom = custom_merge(plan_defaults, custom)
          @item.set_os_deployment_settings(plan, custom)
        end

        def custom_merge(defaults, customs)
          defaults ||= []
          customs ||= []
          customs.each do |custom_attribute|
            custom_replace!(defaults, custom_attribute)
          end
          # At this point, the defaults contain the custom data plus the default attributes
          # It selects all the ones that have 'value', i.e. custom attributes or actual default attributes that have a default 'value'
          # Then it filters these attributes to have only 'name' and 'value' (The only required and accepted parameters in Server profile)
          defaults.select { |merged_attr| merged_attr['value'] }.collect { |cus_attr| { 'name' => cus_attr['name'], 'value' => cus_attr['value'] } }
        end

        def custom_replace!(target, custom_attribute)
          was_replaced = false
          target.collect! do |default_attribute|
            if default_attribute['name'] == custom_attribute['name']
              was_replaced = true
              custom_attribute
            else
              default_attribute
            end
          end
          target << custom_attribute unless was_replaced
        end
      end

      # ServerProfile API300 Synergy provider
      class ServerProfileProvider < API200::ServerProfileProvider
        include OneviewCookbook::API300::Synergy::ServerProfileHelpers
        def create_or_update
          load_os_deployment_plan
          super
        end
      end
    end
  end
end
