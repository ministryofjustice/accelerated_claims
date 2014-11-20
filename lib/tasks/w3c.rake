namespace :w3c do
  desc 'Checks each view against remote w3c validator'
  task validate: :environment do
    ENV['w3c_validate'] = 'true'
    puts 'aaaa'
    RSpec::Core::RakeTask.clear
    RSpec::Core::RakeTask.new(:spec) do |t|
      puts 'bbbb'
      t.pattern = 'spec/helpers/w3c_validation_spec.rb'
    end
    puts 'cccc'
    # Rake::Task["spec"].invoke
    puts 'dddd'
    Rake::Task['spec spec/helpers/w3c_validation_spec.rb'].invoke
  end
end


