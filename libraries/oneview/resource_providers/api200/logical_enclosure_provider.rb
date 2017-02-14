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

require_relative '../../../resource_provider'

module OneviewCookbook
  module API200
    # LogicalEnclosure API200 provider
    class LogicalEnclosureProvider < ResourceProvider
      # Load the enclosure_group & enclosures properties
      def load_logical_enclosure
        if @context.enclosure_group
          eg_klass = resource_named(:EnclosureGroup)
          eg = eg_klass.find_by(@item.client, name: @context.enclosure_group).first
          raise "EnclosureGroup '#{@context.enclosure_group}' not found!" unless eg
          @item['enclosureGroupUri'] = eg['uri']
        end

        @item['enclosureUris'] ||= []
        if @context.enclosures
          enc_klass = resource_named(:Enclosure)
          @context.enclosures.each do |e|
            enc = enc_klass.new(@item.client, name: e, serialNumber: e, activeOaPreferredIP: e, standbyOaPreferredIP: e)
            raise "Enclosure '#{e}' not found!" unless enc.retrieve!
            @item['enclosureUris'].push enc['uri']
          end
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
        raise "LogicalEnclosure '#{@name}' not found!" unless @item.retrieve!
        return if @item['state'] == 'Consistent'
        @context.converge_by "Update LogicalEnclosure '#{@name}' from group" do
          @item.update_from_group
        end
      end

      def reconfigure
        @item.retrieve!
        @item['enclosureUris'].each do |enclosure_uri|
          enclosure = resource_named(:Enclosure).new(@item.client, uri: enclosure_uri)
          enclosure.retrieve!
          next unless ['NotReapplyingConfiguration', 'ReapplyingConfigurationFailed', ''].include? enclosure['reconfigurationState']
          Chef::Log.info "Reconfiguring #{@resource_name} '#{@name}'"
          @context.converge_by "#{@resource_name} '#{@name}' was reconfigured." do
            @item.reconfigure
          end
          return true
        end

        Chef::Log.info("#{@resource_name} '#{@name}' is currently being reconfigured")
      end

      def set_script
        @item.retrieve!
        if @item.get_script.eql? @context.script
          Chef::Log.info("#{@resource_name} '#{@name}' script is up to date")
        else
          Chef::Log.info "Updating #{@resource_name} '#{@name}'"
          Chef::Log.debug "#{@resource_name} '#{@name}' Chef resource differs from OneView resource."
          @context.converge_by "Updated script for #{@resource_name} '#{@name}'" do
            @item.set_script(@context.script)
          end
        end
      end
    end
  end
end
