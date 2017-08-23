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
    # ConnectionTemplate API200 provider
    class ConnectionTemplateProvider < ResourceProvider
      def load_template_from_resource(resource_type, resource_name)
        return unless resource_name
        @item.data.delete('name')
        @item['uri'] = load_resource(resource_type, resource_name, :connectionTemplateUri)
      end

      def load_connection_templates
        resources_set = [@context.associated_ethernet_network, @context.associated_fcoe_network, @context.associated_fc_network,
                         @context.associated_network_set].compact.size
        raise 'A single associated resource field must be specified for this action.' if resources_set > 1
        load_template_from_resource(:EthernetNetwork, @context.associated_ethernet_network)
        load_template_from_resource(:FCoENetwork, @context.associated_fcoe_network)
        load_template_from_resource(:FCNetwork, @context.associated_fc_network)
        load_template_from_resource(:NetworkSet, @context.associated_network_set)
      end

      def create_or_update
        load_connection_templates
        super
      end

      def reset
        load_connection_templates
        @item['bandwidth'] = resource_named(:ConnectionTemplate).get_default(@item.client)['bandwidth']
        create_or_update
      end
    end
  end
end
