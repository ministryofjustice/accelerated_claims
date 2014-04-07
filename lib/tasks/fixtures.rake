namespace :fixtures do
  desc "Recreates spec fixture data from google docs"
  task refresh: :environment do
    require Rails.root.join("lib/create_fixtures_from_csv")
    csvfile = DownloadScenarioData.download
    d = DataScenarioGenerator.new(csvfile)
    d.writeToFile
  end

end
