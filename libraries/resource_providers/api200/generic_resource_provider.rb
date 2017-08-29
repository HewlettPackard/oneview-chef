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
    # Generic Resource Provider methods
    class GenericResourceProvider < ResourceProvider
      def initialize(context)
        @context = context
        @new_resource = context.new_resource
        @resource_name = @new_resource.resource_name
        @name = @new_resource.name
        name_arr = self.class.to_s.split('::')
        name_arr.pop
        @sdk_resource_type = @new_resource.type # e.g., EthernetNetwork
        case name_arr.size
        when 1 # No variant or api version specified. (OneviewCookbook)
          # This case should really only be used for testing
          # Uses the SDK's default api version and variant
          klass = OneviewSDK.resource_named(@sdk_resource_type)
        when 2 # No variant specified. e.g., OneviewCookbook::API200
          @sdk_api_version = name_arr.pop.gsub(/API/i, '').to_i # e.g., 200
          @sdk_variant = nil # Not needed
        when 3 # The variant is specified. e.g., OneviewCookbook::API200::C7000
          @sdk_variant = name_arr.pop # e.g., C7000
          @sdk_api_version = name_arr.pop.gsub(/API/i, '').to_i # e.g., 200
        else # Something is wrong
          raise "Can't build a resource object from the class #{self.class}"
        end
        klass ||= OneviewSDK.resource_named(@sdk_resource_type, @sdk_api_version, @sdk_variant)
        raise "Type '#{@sdk_resource_type}' not found. Please use a valid type defined in the oneview-sdk" unless klass
        c = OneviewCookbook::Helper.build_client(@new_resource.client)
        new_data = JSON.parse(@new_resource.data.to_json) rescue @new_resource.data
        @item = @new_resource.property_is_set?(:api_header_version) ? klass.new(c, new_data, @new_resource.api_header_version) : klass.new(c, new_data)
        @item['name'] ||= @name
      end
    end
  end
end
