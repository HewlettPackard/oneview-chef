# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'bundler'
require 'bundler/setup'
require 'rubocop/rake_task'

task default: :test

RuboCop::RakeTask.new

desc 'Runs foodcritic tests'
task :foodcritic do
  begin
    puts 'Running foodcritic...'
    sh('bundle exec foodcritic -f any .')
    puts 'No offenses detected'
  rescue RuntimeError
    STDERR.puts("\nFoodcritic failed!")
    exit 1
  end
end

desc 'Runs rubocop and foodcritic'
task :test do
  Rake::Task[:rubocop].invoke
  puts ''
  Rake::Task[:foodcritic].invoke
end
