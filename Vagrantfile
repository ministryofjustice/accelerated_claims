# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "base"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.synced_folder "../civil-claims-deploy/providers", "/srv/providers/"
  config.vm.synced_folder "../civil-claims-deploy/salt", "/srv/salt/"
  config.vm.synced_folder "../config/projects/civil-claims/pillar", "/srv/pillar/"

  command = "mkdir -p /etc/salt && cp /srv/salt/minions/vagrant/templates/minion /etc/salt/minion"
  config.vm.provision :shell, :inline => command

  config.vm.provision :salt do |salt|

  salt.install_master = true

    salt.minion_config = "../civil-claims-deploy/salt/minions/vagrant/templates/minion"

    salt.minion_key = '../civil-claims-deploy/salt/minions/vagrant/templates/key'
    salt.minion_pub = '../civil-claims-deploy/salt/minions/vagrant/templates/key.pub'
    salt.seed_master = {minion: salt.minion_pub}

    salt.run_highstate = true

    salt.verbose = true

  end
end
