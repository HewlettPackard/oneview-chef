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
  module API800
    module C7000
<<<<<<< HEAD
      # StorageSystem API600 C7000 provider
=======
      # StorageSystem API800 C7000 provider
>>>>>>> bc1d2b4c731ed9ec46e6a1d2bbbc0b706781b022
      class StorageSystemProvider < API600::C7000::StorageSystemProvider
        include OneviewCookbook::RefreshActions::RequestRefresh
      end
    end
  end
end
