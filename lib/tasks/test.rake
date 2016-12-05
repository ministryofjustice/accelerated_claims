namespace :spec do
  desc 'run all tests in docker container'
  task :docker do
    exit system 'rspec'
  end

  desc 'Run all tests excluding the submit js tests'
  task :all_exclude_js_submit do
    exit system 'rspec --tag ~slow'
  end

	desc 'run feature tests'
	task :features do
		exit system 'env=docker rspec spec/features'
	end

  desc 'Run (the normally excluded) submit js tests'
  task :features_only_js_submit do
    exit system 'rspec spec/features/submit_claim_spec.rb  --tag slow'
  end
end
