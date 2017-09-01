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

require_relative 'connection_template_provider'

module OneviewCookbook
  module API200
    # EthernetNetworkProvider
    class EthernetNetworkProvider < ResourceProvider
      include API200::ConnectionTemplateProvider::ConnectionTemplateHelper

      def create_or_update
        bandwidth = @item.data.delete('bandwidth')
        super
        update_connection_template(bandwidth: bandwidth) if bandwidth
      end

      def create_if_missing
        bandwidth = @item.data.delete('bandwidth')
        created = super
        update_connection_template(bandwidth: bandwidth) if bandwidth && created
      end
    end
  end
end
