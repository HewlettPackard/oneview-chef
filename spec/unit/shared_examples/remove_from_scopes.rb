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
#  scope_class - Full name of Oneview Scope resource used in the test
#  target_match_method - Array with name of match method called and with the argument of the match method,
#    e.g: let(:target_match_method) { [:add_oneview_enclosure_to_scopes, 'EnclosureName'] }

RSpec.shared_examples 'action :remove_from_scopes' do
  let(:scope1) { scope_class.new(client, name: 'Scope1', uri: '/rest/fake/1') }
  let(:scope2) { scope_class.new(client, name: 'Scope2', uri: '/rest/fake/2') }

  before do
    allow(scope_class).to receive(:new).and_return(scope1, scope2)
    allow(scope1).to receive(:retrieve!).and_return(true)
    allow(scope2).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(target_class).to receive(:[]).and_call_original
  end

  it 'removes all scopes when are not removed' do
    allow_any_instance_of(target_class).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1', '/rest/fake/2'])
    expect_any_instance_of(target_class).to receive(:remove_scope).with(scope1)
    expect_any_instance_of(target_class).to receive(:remove_scope).with(scope2)
    expect(real_chef_run).to send(*target_match_method)
  end

  it 'removes only the one scope that is not removed' do
    allow_any_instance_of(target_class).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1'])
    expect_any_instance_of(target_class).to receive(:remove_scope).with(scope1)
    expect_any_instance_of(target_class).not_to receive(:remove_scope).with(scope2)
    expect(real_chef_run).to send(*target_match_method)
  end

  it 'does nothing when scope is already removed' do
    allow_any_instance_of(target_class).to receive(:[]).with('scopeUris').and_return(['/rest/fake/other-scope'])
    expect_any_instance_of(target_class).not_to receive(:remove_scope)
    expect(real_chef_run).to send(*target_match_method)
  end
end
