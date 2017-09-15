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
  module API500
    module C7000
      # Server Profile Template API500 C7000 provider
      class ServerProfileTemplateProvider < API300::C7000::ServerProfileTemplateProvider
        # Override create method to allow creation from a template
        def create(method)
          if @new_resource.server_profile_name
            sp_as_template = load_resource(:ServerProfile, @new_resource.server_profile_name)
            Chef::Log.info "Using Server profile '#{@new_resource.server_profile_name}' as template to #{method} #{@resource_name} '#{@name}'"
            new_spt_data = sp_as_template.get_profile_template.data
            @item.data = new_spt_data.merge(@item.data)
          end
          super
        end
      end
    end
  end
end
