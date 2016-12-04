namespace :spec do 

	desc 'run all tests in docker container' 
	task :docker do
		exit system 'rspec spec/models spec/lib spec/routing spec/controllers'
	end


	desc 'run feature tests' 
	task :features do
		exit system 'env=docker rspec spec/features'
	end
	
end