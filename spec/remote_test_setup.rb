def remote_hosts
  {
  'dev' => 'civilclaims.local',
  'demo'  => 'civilclaims.dsd.io',
  'staging' => 'civilclaimsstaging.dsd.io',
  'production' => 'alpha:Cl1v3@civilclaims.service.dsd.io'
  }
end

def remote_host
  unless remote_hosts.keys.include? ENV['env']
    puts ["Execution failed.","Remote host options are :"].concat(remote_hosts.keys).join("\n")
    exit(1)
  end
  remote_hosts[ENV['env']]
end

Capybara.run_server = false
Capybara.app_host = "https://#{remote_host}/accelerated"
puts "Running tests remotely against " + Capybara.app_host
Capybara.default_driver = Capybara.javascript_driver
WebMock.disable! if defined? WebMock

