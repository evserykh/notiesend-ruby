require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new
RuboCop::RakeTask.new { |task| task.options = ['--cache=false'] }

task default: %i[spec rubocop]
