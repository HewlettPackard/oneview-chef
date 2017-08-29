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
    # User API200 provider
    class UserProvider < ResourceProvider
      def initialize(context)
        super
        n = @item.data.delete('name')
        @item['userName'] ||= n
      end

      def create_or_update
        pw = @item.exists? ? @item.data.delete('password') : nil
        super
        return unless pw
        opts = {
          api_version: @item.client.api_version,
          url: @item.client.url,
          user: @item['userName'],
          password: pw,
          ssl_enabled: @item.client.ssl_enabled,
          log_level: :error
        }
        begin
          OneviewCookbook::Helper.build_client(opts)
          Chef::Log.info "#{@resource_name} '#{@name}' password is up to date"
        rescue StandardError => e
          raise e unless e.message =~ /Invalid username or password/
          Chef::Log.info "Setting #{@resource_name} '#{@name}' password"
          @context.converge_by "Set password for #{@resource_name} '#{@name}'\n" do
            @item.update(password: pw)
          end
        end
      end
    end
  end
end
