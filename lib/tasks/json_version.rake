# rake json:version creates a version.json file with information about the current state
# which can be interrogated from the browser.
#
# Only works in development mode as in production a different version of this file is created 
# during deploy
#
namespace :json do

  desc 'Create development environment version.json'
  task :version do
    require_relative 'rake_task_helpers/development_version_file_creator'
    RakeTaskHelper::DevelopmentVersionFileCreator.new.run
  end
end


