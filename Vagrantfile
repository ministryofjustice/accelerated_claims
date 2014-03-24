# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "base"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # you'll be wanting to add civilclaims.local to /etc/hosts 
  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.synced_folder "../civil-claims-deploy/providers", "/srv/providers/"
  config.vm.synced_folder "../civil-claims-deploy/salt", "/srv/salt/"
  config.vm.synced_folder "../config/projects/civil-claims/pillar", "/srv/pillar/"

  config.vm.provision :salt do |salt|

    minion_config_dir   = '../civil-claims-deploy/salt/minions/vagrant/templates/'
    salt.minion_config  = minion_config_dir + "minion"
    salt.minion_key     = minion_config_dir + 'key'
    salt.minion_pub     = minion_config_dir + 'key.pub'

    salt.install_master = false
    salt.seed_master = {vagrant: salt.minion_pub}

    # Pass extra flags to bootstrap script
    salt.bootstrap_options = "-D"

    salt.verbose = true

  end
  
  hacks = [
    'mkdir -p /etc/salt',
    'cp /srv/salt/minions/vagrant/templates/minion /etc/salt/minion',
    'salt-key -A --yes || true',
    'service salt-minion restart',
    'sleep 5', # This might not be needed, but why rush these things?
    "salt-call state.highstate --local --retcode-passthrough",
  ]
  hacks.each do |cmd|
    config.vm.provision :shell, inline: cmd
  end
  
  
end
