namespace :journey do
  desc 'run a particular journey as JOURNEY=nn, where "nn" is the journey number'
  task :run do
    system "JOURNEY=#{ENV['JOURNEY']} bundle exec rspec spec/features/submit_claim_spec.rb"
  end
end
