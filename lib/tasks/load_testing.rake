require_relative 'rake_task_helpers/load_test_runner'

namespace :load do

  namespace :dev do

    desc 'Run single-user load test in development environment'
    task :single_user do
      LoadTestRunner.new(:development, :single_user)
    end

  end

end