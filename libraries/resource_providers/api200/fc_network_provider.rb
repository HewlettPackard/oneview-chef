# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative 'ethernet_network_provider'

module OneviewCookbook
  module API200
    # FC Network Provider resource methods
    class FCNetworkProvider < EthernetNetworkProvider
      def load_associated_san
        return unless @new_resource.associated_san
        san = resource_named(:ManagedSAN).new(@item.client, name: @new_resource.associated_san)
        raise "SAN '#{san['name']}' not found!" unless san.retrieve!
        @item['managedSanUri'] = san['uri']
      end

      def create_or_update
        load_associated_san
        super
      end

      def create_if_missing
        load_associated_san
        super
      end
    end
  end
end
