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
  module ImageStreamer
    module API300
      # DeploymentPlan Provider resource methods
      class DeploymentPlanProvider < ResourceProvider
        def create_or_update
          @item['goldenImageURI'] ||= load_resource(:GoldenImage, @new_resource.golden_image, :uri)
          @item['oeBuildPlanURI'] ||= load_resource(:BuildPlan, @new_resource.os_build_plan, :uri)
          super
        end

        def create_if_missing
          @item['goldenImageURI'] ||= load_resource(:GoldenImage, @new_resource.golden_image, :uri)
          @item['oeBuildPlanURI'] ||= load_resource(:BuildPlan, @new_resource.os_build_plan, :uri)
          super
        end
      end
    end
  end
end
