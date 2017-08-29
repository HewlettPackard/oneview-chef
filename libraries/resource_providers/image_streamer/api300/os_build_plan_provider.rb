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
      # OS Build Plan Provider resource methods
      class BuildPlanProvider < ResourceProvider
        def load_build_step
          return unless @item['buildStep']
          @item['buildStep'].collect! do |build_step|
            step = convert_keys(build_step, :to_s)
            next step if step['planScriptUri']
            raise "InvalidResourceData: Must specify the 'planScriptName' or 'planScriptUri' for each build step" unless step['planScriptName']
            step['planScriptUri'] = load_resource(:PlanScript, step['planScriptName'], 'uri')
            step
          end
        end

        def create_or_update
          load_build_step
          super
        end

        def create_if_missing
          load_build_step
          super
        end
      end
    end
  end
end
