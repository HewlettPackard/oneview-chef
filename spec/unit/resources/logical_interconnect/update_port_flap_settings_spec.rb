# (c) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative './../../../spec_helper'

describe 'oneview_test_api2400_c7000::logical_interconnect_update_port_flap_settings' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::API2400::C7000::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
