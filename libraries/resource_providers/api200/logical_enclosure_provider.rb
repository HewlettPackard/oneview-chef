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
    # LogicalEnclosure API200 provider
    class LogicalEnclosureProvider < ResourceProvider
      # Load the enclosure_group & enclosures properties
      def load_logical_enclosure
        @item['enclosureGroupUri'] = load_resource(:EnclosureGroup, @new_resource.enclosure_group, 'uri') if @new_resource.enclosure_group
        @item['enclosureUris'] ||= []
        return unless @new_resource.enclosures
        @new_resource.enclosures.each do |e|
          data = { name: e, serialNumber: e, activeOaPreferredIP: e, standbyOaPreferredIP: e }
          @item['enclosureUris'].push(load_resource(:Enclosure, data, 'uri'))
        end
      end

      def create_or_update
        load_logical_enclosure
        super
      end

      def create_if_missing
        load_logical_enclosure
        super
      end

      def update_from_group
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        return if @item['state'] == 'Consistent'
        @context.converge_by "Update LogicalEnclosure '#{@name}' from group" do
          @item.update_from_group
        end
      end

      def reconfigure
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        @item['enclosureUris'].each do |enclosure_uri|
          enc_state = load_resource(:Enclosure, { uri: enclosure_uri }, 'reconfigurationState')
          next unless ['NotReapplyingConfiguration', 'ReapplyingConfigurationFailed', ''].include?(enc_state)
          Chef::Log.info "Reconfiguring #{@resource_name} '#{@name}'"
          @context.converge_by "#{@resource_name} '#{@name}' was reconfigured." do
            @item.reconfigure
          end
          return true
        end
        Chef::Log.info("#{@resource_name} '#{@name}' is currently being reconfigured")
      end

      def set_script
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        if @item.get_script.eql? @new_resource.script
          Chef::Log.info("#{@resource_name} '#{@name}' script is up to date")
        else
          Chef::Log.info "Updating #{@resource_name} '#{@name}'"
          Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
          @context.converge_by "Updated script for #{@resource_name} '#{@name}'" do
            @item.set_script(@new_resource.script)
          end
        end
      end

      def create_support_dump
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        Chef::Log.info "Creating a support dump for #{@resource_name} '#{@name}'"
        @context.converge_by "Created support dump for #{@resource_name} '#{@name}'" do
          @item.support_dump(@new_resource.dump_options)
        end
      end
    end
  end
end
