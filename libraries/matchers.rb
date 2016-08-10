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

if defined?(ChefSpec)
  # Instead of defining each matcher method, we're going to save some time by doing some meta programming
  # To see a full list of the actual matchers, see spec/unit/resources/matchers_spec.rb
  standard_actions = [:create, :create_if_missing, :delete]
  oneview_resources = {
    oneview_resource:                   standard_actions,
    oneview_enclosure:                  [:add, :remove],
    oneview_enclosure_group:            standard_actions + [:set_script],
    oneview_ethernet_network:           standard_actions,
    oneview_fc_network:                 standard_actions,
    oneview_fcoe_network:               standard_actions,
    oneview_logical_enclosure:          [:update_from_group],
    oneview_logical_interconnect_group: standard_actions,
    oneview_storage_pool:               [:add, :remove],
    oneview_storage_system:             [:add, :remove],
    oneview_volume:                     standard_actions,
    oneview_volume_template:            standard_actions
  }

  oneview_resources.each do |resource_type, actions|
    actions.each do |action|
      method_name = case action
                    when :create_if_missing then "create_#{resource_type}_if_missing"
                    when :update_from_group then "update_#{resource_type}_from_group"
                    when :set_script then "set_#{resource_type}_script"
                    else "#{action}_#{resource_type}"
                    end
      define_method(method_name) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(resource_type, action, resource_name)
      end
    end
  end
end
