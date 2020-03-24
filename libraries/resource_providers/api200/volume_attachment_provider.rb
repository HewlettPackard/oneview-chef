# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
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
    # VolumeAttachement API200 provider
    class VolumeAttachmentProvider < ResourceProvider
      def repair
        return false unless @item.retrieve!
        Chef::Log.info "Removing extra presentations from #{@resource_name} '#{@name}'"
        @context.converge_by "Removing extra presentations from #{@resource_name} '#{@name}'" do
          @item.repair
        end
        true
      end
    end
  end
end
