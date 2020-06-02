# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
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
  module API1600
    module C7000
      # Hypervisor Cluster Profile API1600 provider
      class HypervisorClusterProfileProvider < API1200::C7000::HypervisorClusterProfileProvider
        def delete
          return false unless @item.retrieve!
          Chef::Log.info "Deleting oneview_hypervisor_cluster_profile '#{@name}'"
          @context.converge_by "Deleted oneview_hypervisor_cluster_profile '#{@name}'" do
	    if @item.data['softDelete'] or @item.data['force']
	      @item.delete(@item.data['softDelete'],@item.data['force'])
	    else
	      @item.delete
	    end
          end
          true
        end
      end
    end
  end
end
