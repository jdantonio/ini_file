require "rubygems"
require "bundler/gem_tasks"
require "rspec"
require "rspec/core/rake_task"

$:.unshift 'tasks'
Dir.glob('tasks/**/*.rake').each do|rakefile|
  load rakefile
end

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-fd --color'
end

task :default => [:spec]
