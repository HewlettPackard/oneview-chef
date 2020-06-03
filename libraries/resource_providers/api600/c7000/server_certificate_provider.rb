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
  module API600
    module C7000
      # ServerCertificate API600 C7000 provider
      class ServerCertificateProvider < ResourceProvider
        def import_certificate
          @item.data['remoteIp'] = @item.data['name']
          x = @item.get_certificate
          @item.data.clear
          @item.data['certificateDetails'] = []
          @item.data['certificateDetails'][0] = {
            'type' => x['certificateDetails'][0]['type'],
            'base64Data' => x['certificateDetails'][0]['base64Data']
          }
          @item.import
          Chef::Log.info 'SSL_CERTIFCATE IMPORTED SUCCESSFULLY'
        end

        def remove_certificate
          @item.data['aliasName'] = @item.data['name']
          @item.remove
          Chef::Log.info 'SSL_CERTIFCATE REMOVED SUCCESSFULLY'
        end

        def update_certificate
          item.data['aliasName'] = item.data['name']
          alias_name = item.data['name']
          @item.retrieve!
          Chef::Log.info 'SSL_CERTIFCATE FOUND'
          item.data.clear
          @item.data['remoteIp'] = alias_name
          x = @item.get_certificate
          @item.data.clear
          @item.data['type'] = x['type']
          @item.data['certificateDetails'] = []
          @item.data['certificateDetails'][0] = {
            'type' => x['certificateDetails'][0]['type'],
            'aliasName' => alias_name,
            'base64Data' => x['certificateDetails'][0]['base64Data']
          }
          @item.data['uri'] = "/rest/certificates/servers/#{alias_name}"
          item.update
          Chef::Log.info 'SSL_CERTIFICATE UPDATED'
        end
      end
    end
  end
end
