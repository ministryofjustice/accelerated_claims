namespace :w3c do
  desc 'Checks each view against remote w3c validator'
  task validate: :environment do
    ENV['w3c_validate'] = 'true'
    task :validate_task => []
    Rake::Task[:validate_task].clear
    RSpec::Core::RakeTask.new(:validate_task) do |t|
      t.pattern = 'spec/features/w3c_validation_spec.rb'
    end
    Rake::Task[:validate_task].invoke
  end
end


