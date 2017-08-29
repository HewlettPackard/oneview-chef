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

module OneviewCookbook
  # Define default properties for all resources
  module ResourceBaseProperties
    # Loads the default properties for all resources
    def self.load(context)
      context.property :client
      context.property :name, [String, Symbol], required: true
      context.property :data, Hash, default: {}
      context.property :save_resource_info, [TrueClass, FalseClass, Array], default: safe_dup(context.node['oneview']['save_resource_info'])
      context.property :api_version, Integer, default: safe_dup(context.node['oneview']['api_version'])
      context.property :api_variant, [String, Symbol], default: safe_dup(context.node['oneview']['api_variant'])
      context.property :api_header_version, Integer    # Overrides X-API-Version headers in API requests
      context.property :operation, String              # To be used with :patch action
      context.property :path, String                   # To be used with :patch action
      context.property :value, [String, Array]         # To be used with :patch action
    end

    def self.safe_dup(object)
      object.dup
    rescue TypeError
      object
    end
  end
end
