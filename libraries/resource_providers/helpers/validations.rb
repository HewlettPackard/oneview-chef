# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewCookbook
  # module for validations of resource providers
  module Validations
    # module with method related to validate the presence of properties
    module Presence
      # Validates the presence of properties
      # @param [Symbol] property An property name to be validating presence
      # @param [Symbol] ... More property names
      # @raise [RuntimeError] if some property is not set
      def validate_presence_of(*properties)
        properties.each do |property|
          raise "Unspecified property: '#{property}'. Please set it before attempting this action." unless @new_resource.public_send(property)
        end
      end
    end
  end
end
