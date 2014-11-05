def remote_hosts
  {
    'dev' => 'civilclaims.local',
    'demo'  => 'civilclaims.dsd.io',
    'demo1' => 'civilclaims.demo1.civilclaims.dsd.io',
    'demo2' => 'civilclaims.demo2.civilclaims.dsd.io',
    'staging' => 'civil:mojcivil@civilclaimsstaging.dsd.io',
    'production' => 'civilclaims.service.gov.uk'
  }
end

def remote_host
  unless remote_hosts.keys.include? ENV['env']
    puts ['---',"Execution failed. Set remote host e.g. env=demo", "Remote host options are:"].concat(remote_hosts.keys).join("\n")
    exit(1)
  end
  remote_hosts[ENV['env']]
end

Capybara.run_server = false
Capybara.app_host = "https://#{remote_host}/accelerated-possession-eviction"
puts "Running tests remotely against " + Capybara.app_host
Capybara.default_driver = Capybara.javascript_driver
WebMock.disable! if defined? WebMock
Capybara.default_wait_time = 30
