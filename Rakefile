# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if Rails.env.development? || Rails.env.test?
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  desc 'Run RuboCop'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.fail_on_error = true
    task.options = %w(-D --auto-correct)
  end

  task default: [:rubocop, :spec]
end
