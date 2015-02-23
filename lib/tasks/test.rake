namespace :spec do 

	desc 'run all tests in docker container' 
	task :docker do
		system 'rspec spec/models spec/lib spec/routing spec/controllers'
	end


	desc 'run feature tests' 
	task :features do
		system 'rspec spec/features'
	end
	
end