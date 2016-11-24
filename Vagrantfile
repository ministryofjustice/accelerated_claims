# -*- mode: ruby -*-
# vi: set ft=ruby :

DOCKER_IMAGE_TAG='accelerated-claims'
DOCKER_PORT=2378
UNICORN_PORT=3002
VAGRANTFILE_API_VERSION = "2"

DOCKER_ENABLED_BOX="puppetlabs/ubuntu-14.04-64-nocm"

$docker_setup=<<CONF
cat > /etc/default/docker << 'EOF'
DOCKER_OPTS="-H 0.0.0.0:#{DOCKER_PORT} -H unix:///var/run/docker.sock"
EOF
service docker restart
sleep 5
docker stop accelerated-claims >/dev/null 2>&1 || true
docker rm accelerated-claims >/dev/null 2>&1 || true
docker rmi -f accelerated-claims >/dev/null 2>&1 || true
CONF

$testing_setup=<<GECKO
docker exec accelerated-claims wget -O /usr/local/bin/geckodriver-v0.11.1-linux64.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.11.1/geckodriver-v0.11.1-linux64.tar.gz
docker exec accelerated-claims tar -xf /usr/local/bin/geckodriver-v0.11.1-linux64.tar.gz -C /usr/local/bin/
docker exec accelerated-claims rm -rf /usr/local/bin/geckodriver-v0.11.1-linux64.tar.gz
docker exec accelerated-claims wget -O /usr/local/bin/firefox-50.0.tar.bz2 http://ftp.mozilla.org/pub/firefox/releases/50.0/linux-x86_64/en-GB/firefox-50.0.tar.bz2
docker exec accelerated-claims tar xvjf /usr/local/bin/firefox-50.0.tar.bz2 -C /usr/local/bin/
docker exec accelerated-claims rm -rf /usr/local/bin/firefox-50.0.tar.bz2
GECKO

unless Vagrant.has_plugin?("vagrant-cachier")
  puts "WARNING: vagrant-cachier plugin is not installed! It really speeds this up..."
  puts "         Install using 'vagrant plugin install vagrant-cachier'"
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = DOCKER_ENABLED_BOX
  config.vm.hostname = "#{DOCKER_IMAGE_TAG}-dockerhost"
  config.vm.network "forwarded_port", guest: DOCKER_PORT, host: DOCKER_PORT
  config.vm.network "forwarded_port", guest: UNICORN_PORT, host: UNICORN_PORT

  # Set up SSH agent forwarding.
  config.ssh.forward_agent = true

  config.vm.provision "docker"
  config.vm.provision "shell", inline: $docker_setup

  # build image and start the application
  #  rails 4.2.0 need explicit binding to 0.0.0.0 now
  #  use /tmp/server.pid so that we don't prevent future runs from firing up.
  config.vm.provision "docker" do |d|
    d.build_image "/vagrant", args: "-t #{DOCKER_IMAGE_TAG}"
    d.run "#{DOCKER_IMAGE_TAG}",
      image: "#{DOCKER_IMAGE_TAG}",
      args: "-v /vagrant:/usr/src/app -p #{UNICORN_PORT}:3000"
  end
  config.vm.provision "shell", inline: 'docker exec accelerated-claims bundle install --with development test'
  config.vm.provision "shell", inline: $testing_setup
  # config.vm.provision "shell", inline: 'docker exec accelerated-claims wget -O /usr/local/bin/geckodriver-v0.11.1-linux64.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.11.1/geckodriver-v0.11.1-linux64.tar.gz && tar -xf /usr/local/bin/geckodriver-v0.11.1-linux64.tar.gz && rm -rf /usr/local/bin/geckodriver-v0.11.1-linux64.tar.gz'
  # config.vm.provision "shell", inline: 'docker exec accelerated-claims `cd /usr/local` && wget http://ftp.mozilla.org/pub/firefox/releases/50.0/linux-x86_64/en-GB/firefox-50.0.tar.bz2 && tar xvjf firefox-50.0.tar.bz2 && rm -rf firefox-48.0.2.tar.bz2'

  # print out help
  config.vm.provision "shell", inline: <<-EOF
    echo "#---------------------------------------"
    echo "# Application should be available at:"
    echo "#  http://localhost:#{UNICORN_PORT}"
    echo "#---------------------------------------"
    echo "# To use docker locally, set:"
    echo "export DOCKER_HOST=tcp://localhost:#{DOCKER_PORT}"
    echo "#---------------------------------------"
    echo "# To run tests on docker directly, run:"
    echo "DOCKER_HOST=tcp://localhost:#{DOCKER_PORT} docker exec -ti accelerated-claims rake spec:docker"
  EOF

end
