def remote_hosts
  {
    'dev' => 'https://civilclaims.local/accelerated-possession-eviction',
    'demo'  => 'https://civilclaims.dsd.io/accelerated-possession-eviction',
    'demo1' => 'https://civilclaims.demo1.civilclaims.dsd.io/accelerated-possession-eviction',
    'demo2' => 'https://civilclaims.demo2.civilclaims.dsd.io/accelerated-possession-eviction',
    'staging' => 'https://civil:mojcivil@civilclaimsstaging.dsd.io/accelerated-possession-eviction',
    'production' => 'https://civilclaims.service.gov.uk/accelerated-possession-eviction',
    'docker' => 'http://localhost:3002'
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
Capybara.app_host = remote_host

puts "Running tests remotely against " + Capybara.app_host
Capybara.default_driver = Capybara.javascript_driver
WebMock.disable! if defined? WebMock
Capybara.default_wait_time = 30
