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

guard :rspec, cmd: 'bundle exec rspec --color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^libraries/(.+)\.rb$}) { |m| "spec/unit/libraries/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')    { 'spec' }
end

group :style, halt_on_fail: true do
  guard :rubocop, cli: ['-D'] do
    watch('Gemfile')
    watch('Rakefile')
    watch('Guardfile')
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end

  guard 'rake', task: 'foodcritic' do
    watch(/.+\.rb$/)
  end
end
