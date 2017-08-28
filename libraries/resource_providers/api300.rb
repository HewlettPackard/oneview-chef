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

require_relative 'api200'

module OneviewCookbook
  # Module for Oneview API 300 Resources
  module API300
    SUPPORTED_VARIANTS ||= %w[C7000 Synergy].freeze

    # Get resource class that matches the type given
    # @param [String] type Name of the desired class type
    # @param [String] variant Variant (C7000 or Synergy)
    # @raise [RuntimeError] if resource class not found
    # @return [Class] Resource class
    def self.provider_named(type, variant)
      OneviewCookbook::Helper.get_provider_named(type, self, variant)
    end
  end
end

# Load all API-specific resources:
Dir[File.dirname(__FILE__) + '/api300/*.rb'].each { |file| require file }
