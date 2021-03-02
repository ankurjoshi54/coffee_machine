require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Add rake task `spec` to run test cases
RSpec::Core::RakeTask.new(:spec)

# Add rake task `lint` and `lint:auto_correct` for linting
RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = %w(lib/**/*.rb spec/**/*.rb)
end

task :default => :spec
