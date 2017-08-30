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

require_relative '../../api300/synergy/id_pool_provider'

module OneviewCookbook
  module API500
    module Synergy
      # IDPool API500 Synergy provider
      class IDPoolProvider < OneviewCookbook::API300::Synergy::IDPoolProvider
      end
    end
  end
end
