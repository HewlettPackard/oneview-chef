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
  # module for action related to reapply configuration of resource
  module ReapplyConfigurationAction
    def reapply_configuration
      @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
      Chef::Log.info "Reapplying configuration in #{@resource_name} '#{@name}'"
      @context.converge_by "Reapplied configuration in #{@resource_name} '#{@name}'" do
        @item.configuration
      end
    end
  end
end
