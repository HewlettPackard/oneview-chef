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

OneviewCookbook::ResourceBaseProperties.load(self)

property :logical_switch_group, String
property :host, String
property :ssh_credentials, Hash
property :snmp_credentials, Hash

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase

  def load_logical_switch
    item = load_resource
    lsg_defined = logical_switch_group || item['LogicalSwitchGroupUri']
    raise "Undefined Property: 'logical_switch_group'. Please set it before attempting this action" unless lsg_defined
    item.set_logical_switch_group(OneviewSDK::LogicalSwitchGroup.find_by(item.client, name: logical_switch_group).first)

    # This will avoid overriding the 'logicalSwitchCredentials' if already specified in data
    return item unless item['logicalSwitchCredentials']

    # Check if the credential properties are set
    raise "Undefined Property: 'host'. Please set it before attempting this action" unless host
    raise "Undefined Property: 'ssh_credentials'. Please set it before attempting this action" unless ssh_credentials
    raise "Undefined Property: 'snmp_credentials'. Please set it before attempting this action" unless snmp_credentials

    parsed_ssh_credentials = convert_keys(ssh_credentials, :to_sym)
    parsed_snmp_credentials = convert_keys(snmp_credentials, :to_sym)

    # Building the SSH Credential
    # This will create the Struct and then associate the pairs in the order required by it
    ssh_struct = OneviewSDK::LogicalSwitch::CredentialsSSH.new *OneviewSDK::LogicalSwitch::CredentialsSSH.members.map do |key|
      parsed_ssh_credentials[:key]
    end

    # Building the SNMP Credential
    # Selects the correct SNMP Credential type
    snmp_type = case parsed_snmp_credentials[:version]
                when 'SNMPv1' then OneviewSDK::LogicalSwitch::CredentialsSNMPV1
                when 'SNMPv3' then OneviewSDK::LogicalSwitch::CredentialsSNMPV3
                end

    # This will create the Struct and then associate the pairs in the order required by it
    snmp_struct = snmp_type.new *snmp_type.members.map { |key| parsed_snmp_credentials[:key] }

    item.set_switch_credentials(host, ssh_struct, snmp_struct)
    item
  end
end

action :create do
  create_or_update(load_logical_switch)
end

action :create_if_missing do
  create_if_missing(load_logical_switch)
end

action :delete do
  delete
end
