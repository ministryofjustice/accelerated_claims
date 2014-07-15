namespace :browserstack do
  desc 'list browsers for browserstack'
  task :browsers do
    YAML.load_file('config/browsers.json').each_with_index do |b, i|
      puts "#{i + 1}. #{b.values.join(' ')}"
    end
  end

  desc 'run features via browserstack'
  task :run do
    begin
      require 'parallel'

      unless ENV['BS_USERNAME'] && ENV['BS_PASSWORD']
        puts "The BS_USERNAME and BS_PASSWORD environment variables must be set prior to running this task."
        exit
      end

      browsers = YAML.load_file('config/browsers.json')
      nodes = 5

      results = Parallel.map(browsers, in_processes: nodes) do |browser|
        # We're in a subprocess here - set the environment variable BS_BROWSER to the desired browser configuration.
        ENV['BS_BROWSER'] = browser.to_json

        if browser['browserName']
          test_label = ['browserName', 'device'].map { |k| browser[k].gsub(' ','-') }.join('_').downcase
        else
          test_label = ['os', 'os_version', 'browser', 'browser_version'].map { |k| browser[k].gsub(' ','-') }.join('_').downcase
        end

        puts "testing: #{test_label}"

        cmd = "env=#{ENV['env']} rspec spec/features --format RspecJunitFormatter --out '#{test_label}.xml'"
        puts cmd
        system(cmd)
      end
      exitstatus = results.count { |e| !e }
    rescue Exception => e
      pp e
    end
  end
end

# Ugly hack to prevent running features when browserstack environment variables are defined.
RSpec::Core::RakeTask.class_eval do
  def files_to_run
    FileList[pattern].reject { |f| f.include?('feature') }.sort.map { |f| shellescape(f) }
  end
end if ENV['BS_USERNAME']

