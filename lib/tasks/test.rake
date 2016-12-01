namespace :spec do 

	desc 'run all tests in docker container' 
	task :docker do
		system 'rspec spec/models spec/lib spec/routing spec/controllers'
	end

	desc 'run feature tests' 
	task :features do
		system 'env=docker rspec spec/features --tag ~slow'
	end

	desc 'run smoke tests'
	task :smoke do
		system 'env=docker rspec spec/features --tag slow'
	end
end
