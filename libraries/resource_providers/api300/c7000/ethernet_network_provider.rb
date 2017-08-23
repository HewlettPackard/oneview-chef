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
  module API300
    module C7000
      # EthernetNetworkProvider API300 C7000 provider
      class EthernetNetworkProvider < OneviewCookbook::API200::EthernetNetworkProvider
        def add_scope
          scope = load_scope(@context.scope)
          if @item['scopeUris'].include?(scope['uri'])
            Chef::Log.info("Scope '#{scope['name']}'' already added to #{@resource_name} '#{@name}'. Skipping")
          else
            @item.add_scope(scope)
          end
          save_res_info
        end

        def remove_scope
          scope = load_scope(@context.scope)
          if @item['scopeUris'].include?(scope['uri'])
            Chef::Log.info("Scope '#{scope['name']}'' already removed from #{@resource_name} '#{@name}'. Skipping")
          else
            @item.remove_scope(scope)
          end
        end

        def replace_scopes
          scopes = @context.scopes.map { |scope_name| load_scope(scope_name) }
          @item.replace_scopes(scopes)
        end

        def load_scope(scope_name)
          scope = resource_named(:Scope).find_by(@context.client, name: scope_name).first
          raise "#{scope} '#{@name}' not found!" unless scope
          scope
        end
      end
    end
  end
end
