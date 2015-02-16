require_relative 'rake_task_helpers/load_test_runner'

namespace :load_test do

  desc 'Run response-time load test'
  task :response => :environment do
    LoadTestRunner.new(:response).run
  end

  desc 'Run breakpoint load test'
  task :breakpoint => :environment do
    LoadTestRunner.new(:breakpoint).run
  end
end


