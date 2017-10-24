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
    # Interconnect API200 provider
    class InterconnectProvider < ResourceProvider
      include OneviewCookbook::PatchOperations::OnOff
      include OneviewCookbook::PatchOperations::Reset
      include OneviewCookbook::PortActions::UpdatePort

      def reset
        reset_handler('/deviceResetState')
      end

      def reset_port_protection
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        # Nothing to verify
        @context.converge_by "Reset #{@resource_name} '#{@name}' port protection" do
          @item.reset_port_protection
        end
      end
    end
  end
end
