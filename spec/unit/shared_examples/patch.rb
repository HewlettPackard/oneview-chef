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
#  target_match_method - Array with name of match method called and with the argument of the match method,
#    e.g: let(:target_match_method) { [:add_oneview_enclosure_to_scopes, 'EnclosureName'] }

RSpec.shared_examples 'action :patch' do
  it 'performs patch operation' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to send(*target_match_method)
  end
end
