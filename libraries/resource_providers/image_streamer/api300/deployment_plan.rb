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
        # @param [String, Symbol] i3s_resource_type Type of image streamer resource to be retrieved. e.g., ':GoldenImage'.
        # @param [String] i3s_resource_name Name of the resource from context.
        def load_i3s_resource(i3s_resource_type, i3s_resource_name)
          return unless i3s_resource_name
          resource_instance = resource_named(i3s_resource_type).new(@item.client, name: i3s_resource_name)
          raise "#{i3s_resource_type} resource with name '#{i3s_resource_name}' was not found in the appliance." unless resource_instance.retrieve!
          resource_instance['uri']
        end

        def create_or_update
          @item['goldenImageURI'] = load_i3s_resource(:GoldenImage, @context.golden_image)
          @item['oeBuildPlanURI'] = load_i3s_resource(:BuildPlan, @context.build_plan)
          super
        end

        def create_if_missing
          @item['goldenImageURI'] = load_i3s_resource(:GoldenImage, @context.golden_image)
          @item['oeBuildPlanURI'] = load_i3s_resource(:BuildPlan, @context.build_plan)
          super
        end
      end
    end
  end
end
