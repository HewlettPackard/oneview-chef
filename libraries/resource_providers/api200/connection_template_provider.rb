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
      def load_connection_template
        if @context.associated_ethernet_network
          resource_class_name = :EthernetNetwork
          resource_name = @context.associated_ethernet_network
        elsif @context.associated_fc_network
          resource_class_name = :FcNetwork
          resource_name = @context.associated_fc_network
        elsif @context.associated_network_set
          resource_class_name = :NetworkSet
          resource_name = @context.associated_network_set
        elsif @context.associated_fcoe_network
          resource_class_name = :FCoENetwork
          resource_name = @context.associated_fcoe_network
        else
          return
        end
        @item.data.delete('name')
        res = load_resource(resource_class_name, resource_name)
        @item['uri'] = res['connectionTemplateUri']
      end

      def create_or_update
        load_connection_template
        super
      end

      def reset
        load_connection_template
        @item['bandwidth'] = resource_named(:ConnectionTemplate).get_default(@item.client)['bandwidth']
        create_or_update
      end
    end
  end
end
