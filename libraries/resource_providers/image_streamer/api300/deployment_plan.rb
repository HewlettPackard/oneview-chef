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
  module ImageStreamer
    module API300
      # DeploymentPlan Provider resource methods
      class DeploymentPlanProvider < ResourceProvider
        # Generic method to retrieve and return the URI from different image streamer resources using the name of the resource
        # @param [String, Symbol] resource_field Name of the field which will be receiving a resource name. e.g., 'golden_image'
        def load_i3s_resource(resource_field)
          return unless @context.method(resource_field).call
          resource_name = @context.method(resource_field).call
          klass_name = resource_field.to_s.split('_').collect(&:capitalize).join
          resource_instance = resource_named(klass_name).new(@item.client, name: resource_name)
          raise "#{klass_name} resource with name '#{resource_name}' was not found in the appliance." unless resource_instance.retrieve!
          resource_instance['uri']
        end

        def create_or_update
          @item['goldenImageURI'] = load_i3s_resource(:golden_image) if @context.golden_image
          @item['oeBuildPlanURI'] = load_i3s_resource(:build_plan) if @context.build_plan
          super
        end

        def create_if_missing
          @item['goldenImageURI'] = load_i3s_resource(:golden_image) if @context.golden_image
          @item['oeBuildPlanURI'] = load_i3s_resource(:build_plan) if @context.build_plan
          super
        end
      end
    end
  end
end
