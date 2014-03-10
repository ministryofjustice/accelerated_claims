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

    minion_config_dir   = '../civil-claims-deploy/salt/minions/vagrant/templates/'
    salt.minion_config  = minion_config_dir + "minion"
    salt.minion_key     = minion_config_dir + 'key'
    salt.minion_pub     = minion_config_dir + 'key.pub'

    salt.install_master = true
    salt.seed_master = {vagrant: salt.minion_pub}

    # Pass extra flags to bootstrap script
    salt.bootstrap_options = "-D"

    salt.verbose = true

  end
  
  hacks = [
    'salt-key -A --yes || true',
    'service salt-minion restart',
    'sleep 5', # This might not be needed, but why rush these things?
    "salt-call state.highstate --retcode-passthrough",
  ]
  hacks.each do |cmd|
    config.vm.provision :shell, inline: cmd
  end
  
  
end
