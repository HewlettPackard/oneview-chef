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
    # Enclosure API200 provider
    class EnclosureProvider < ResourceProvider
      include OneviewCookbook::RefreshActions::SetRefreshState
      def add_or_edit
        if @new_resource.enclosure_group
          eg = resource_named(:EnclosureGroup).new(@item.client, name: @new_resource.enclosure_group)
          @item.set_enclosure_group(eg)
        end
        super
      end

      def reconfigure
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        if ['NotReapplyingConfiguration', 'ReapplyingConfigurationFailed', ''].include? @item['reconfigurationState']
          @context.converge_by "#{@resource_name} '#{@name}' was reconfigured." do
            @item.configuration
          end
        else
          Chef::Log.info("#{@resource_name} '#{@name}' configuration is already running. State: #{@item['reconfigurationState']}")
        end
      end
    end
  end
end
