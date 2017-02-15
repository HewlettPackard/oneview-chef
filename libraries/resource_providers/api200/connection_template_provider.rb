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

require_relative '../../resource_provider'

module OneviewCookbook
  module API200
    # ConnectionTemplate API200 provider
    class ConnectionTemplateProvider < ResourceProvider
      def load_resource_from_ethernet
        return unless @context.associated_ethernet_network
        @item.data.delete('name')
        ethernet = resource_named(:EthernetNetwork).find_by(@item.client, name: @context.associated_ethernet_network).first
        @item['uri'] = ethernet['connectionTemplateUri']
      end

      def create_or_update
        load_resource_from_ethernet
        super
      end

      def reset
        load_resource_from_ethernet
        @item['bandwidth'] = resource_named(:ConnectionTemplate).get_default(@item.client)['bandwidth']
        create_or_update
      end
    end
  end
end
