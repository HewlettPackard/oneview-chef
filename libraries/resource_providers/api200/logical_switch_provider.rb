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
    # LogicalSwitch API200 provider
    class LogicalSwitchProvider < ResourceProvider
      def load_logical_switch
        lsg_defined = @new_resource.logical_switch_group || @item['LogicalSwitchGroupUri']
        raise "Undefined Property: 'logical_switch_group'. Please set it before attempting this action" unless lsg_defined
        unless @item['LogicalSwitchGroupUri']
          @item.set_logical_switch_group(load_resource(:LogicalSwitchGroup, @new_resource.logical_switch_group))
        end
        # This will avoid overriding the 'logicalSwitchCredentials' if already specified in data
        return if @item['logicalSwitchCredentials']
        # Check if the credential properties are set
        raise "Undefined Property: 'credentials'. Please set it before attempting this action" unless @new_resource.credentials
        # Iterate through all the credentials
        @new_resource.credentials.each do |credential|
          parsed_credential = convert_keys(credential, :to_sym)
          # Building the SSH Credential
          # This will create the Struct and then associate the pairs in the order required by it
          ssh_type = resource_named(:LogicalSwitch)::CredentialsSSH
          ssh_struct = ssh_type.new(*ssh_type.members.map { |key| parsed_credential[:ssh_credentials][key] })
          # Building the SNMP Credential
          # Selects the correct SNMP Credential type
          snmpv1 = resource_named(:LogicalSwitch)::CredentialsSNMPV1
          snmpv3 = resource_named(:LogicalSwitch)::CredentialsSNMPV3
          # Bootstrap for comparison
          parsed_credential[:snmp_credentials][:version] = nil
          snmp_type = case parsed_credential[:snmp_credentials].keys.sort
                      when snmpv1.members.sort then snmpv1
                      when snmpv3.members.sort then snmpv3
                      else raise "Could not match any SNMP version configuration with the parameters: #{parsed_credential[:snmp_credentials]}"
                      end
          # This will create the Struct and then associate the pairs in the order required by it
          snmp_struct = snmp_type.new(*snmp_type.members.map { |key| parsed_credential[:snmp_credentials][key] })
          # Set the credentials for one Switch
          @item.set_switch_credentials(parsed_credential[:host], ssh_struct, snmp_struct)
        end
      end

      def create_or_update
        load_logical_switch
        super
      end

      def create_if_missing
        load_logical_switch
        super
      end

      def refresh
        @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        @context.converge_by "Refreshed #{@resource_name} '#{@name}'" do
          @item.refresh_state
        end
      end
    end
  end
end
