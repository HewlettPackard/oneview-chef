# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE:
# This shared example requires the following variables:
#  target_class - Full name of the OneView resource to be tested
#  connection_template_class - Full name of Oneview ConnectionTemplate resource used in the test
#  target_match_method - Array with name of match method called and with the argument of the match method,
#    e.g: let(:target_match_method) { [:reset_oneview_ethernet_network_connection_template, 'EthernetNetworkName'] }

RSpec.shared_examples 'action :reset_connection_template' do
  let(:default_bandwidth) do
    {
      'bandwidth' => {
        'maximumBandwidth' => 10_000,
        'typicalBandwidth' => 2500
      }
    }
  end

  before do
    allow_any_instance_of(target_class).to receive(:[]).and_call_original
    allow_any_instance_of(target_class).to receive(:[]).with('connectionTemplateUri').and_return('/rest/fake-template/1')
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    allow(connection_template_class).to receive(:get_default).and_return(default_bandwidth)
    allow_any_instance_of(connection_template_class).to receive(:retrieve!).and_return(true)
  end

  it 'updates it when it exists but not alike' do
    allow_any_instance_of(connection_template_class).to receive(:like?).and_return(false)
    expect_any_instance_of(connection_template_class).to receive(:update).and_return(true)
    expect(real_chef_run).to send(*target_match_method)
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(connection_template_class).to receive(:like?).and_return(true)
    expect_any_instance_of(connection_template_class).to_not receive(:update)
    expect(real_chef_run).to send(*target_match_method)
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
