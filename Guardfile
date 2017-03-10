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

guard :rspec, cmd: 'bundle exec rspec --color', first_match: true do
  watch('spec/spec_helper.rb') { 'spec' }
  watch(%r{^(spec\/.+_spec\.rb)$}) { |m| m[1] }
  watch('libraries/matchers.rb') { 'spec/unit/resources/matchers_spec.rb' }
  watch(%r{^libraries\/(\w+)\.rb$}) { |m| "spec/unit/libraries/#{m[1]}_spec.rb" }

  # Resources:
  watch(%r{^resources\/(\w+)\.rb$}) { |m| "spec/unit/resources/#{m[1]}" }
  watch(%r{^resources\/image_streamer\/(\w+)\.rb$}) { |m| "spec/unit/resources_image_streamer/#{m[1]}" }

  # Resource providers:
  watch(%r{^libraries\/resource_providers\/image.*\/(\w+)_provider\.rb$}) { |m| "spec/unit/resources_image_streamer/#{m[1]}" }
  watch(%r{^libraries\/resource_providers\/.*\/(\w+)_provider\.rb$}) { |m| "spec/unit/resources/#{m[1]}" }

  # Fixture recipes: There isn't really a good way to run tests specific to individual recipes, so this is the best we can do:
  watch(%r{^spec\/fixtures\/cookbooks\/oneview.+\.rb$}) { 'spec/unit/resources' }
  watch(%r{^spec\/fixtures\/cookbooks\/image.+\.rb$}) { 'spec/unit/resources_image_streamer' }

  # Everything else:
  watch(%r{^(libraries|resources|spec)\/(.+)\.rb$}) { 'spec' }
end

group :style, halt_on_fail: true, first_match: true do
  guard :rubocop, cmd: 'bundle exec rubocop', cli: ['-D'] do
    watch('.rubocop.yml')
    watch(/(.+\.rb)$/) { |m| m[1] }
    watch(/^(Gemfile|Rakefile|Guardfile)$/) { |m| m[1] }
  end

  guard 'rake', task: 'foodcritic' do
    watch(/^(?!spec).+\.rb$/)
  end
end
