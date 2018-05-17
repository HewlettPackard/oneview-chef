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
  module API600
    module Synergy
      # Enclosure API600 Synergy provider
      class EnclosureProvider < API500::Synergy::EnclosureProvider
        # Generate certificate signing request for the enclosure
        def create_csr_request
          @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
          @context.converge_by "Creating CSR request #{@new_resource.csr_data} for bay #{@new_resource.bay_number}" do
            @item.create_csr_request(@new_resource.csr_data, @new_resource.bay_number)
            csr_cert = @item.get_csr_request(@new_resource.bay_number)
            File.open(@new_resource.csr_file_path, 'w') { |f| f.write(csr_cert['base64Data']) }
          end
        end

        # Import certificate into the enclosure
        def import_certificate
          @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
          @context.converge_by "Importing certificate to bay #{@new_resource.bay_number}" do
            certificate_data = nil
            File.open(@new_resource.csr_file_path, 'r') { |f| certificate_data = f.read }
            csr_data = {
              'type' => @new_resource.csr_type,
              'base64Data' => certificate_data
            }
            @item.import_certificate(csr_data, @new_resource.bay_number)
          end
        end
      end
    end
  end
end
