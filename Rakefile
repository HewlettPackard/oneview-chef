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
