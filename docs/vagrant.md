# Using the Vagrant development environment

There's an experimental VM provisioner to create a local development environment. It's hoped this will be useful as a place to test
deployment and infrastructure configuration, and to test against the application in a production-like environment.

To get started, you'll need to have [vagrant](http://www.vagrantup.com/) and [virtualbox](https://www.virtualbox.org/) (along with the 'VirtualBox Extension Pack' from the virtualbox download page) installed and access to the config repo.
The configuration uses a new feature of Vagrant 1.5, so to make it work you need to ensure that you have the correct version of Vagrant installed. Run `vagrant -v` in your console, and if the result shows `Vagrant 1.4.3` or any other number below 1.5.0 then please follow the installation steps above to get the latest version.
You'll also need a [working python environment](https://gist.github.com/munhitsu/1034876) and SWIG (`brew install swig`).

```
echo "192.168.33.10   civilclaims.local" | sudo tee -a  /etc/hosts
mkvirtualenv civil-claims
git clone git@github.com:ministryofjustice/accelerated_claims.git
git clone git@github.com:ministryofjustice/civil-claims-deploy.git
git clone <config git repos>
pip install -r ./civil-claims-deploy/requirements.txt
cd accelerated_claims
vagrant up --provision
```
This will take a few minutes, so now's a good time to make a cup of tea.
If using Xcode 5.1 you may get this error when doing pip install:
```
clang: error: unknown argument: '-mno-fused-madd' [-Wunused-command-line-argument-hard-error-in-future]
```
to which the workaround is:
```
export ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future"
```

Once it finishes, you will be able to see the app landing page on [http://civilclaims.local/accelerated](http://civilclaims.local/accelerated)

Reprovision using the `vagrant provision` command, or completely rebuild with:
```
vagrant destroy -f
cd ..
cd config; git pull; cd ..
cd civil-claims-deploy; git pull; cd ..
cd accelerated_claims
vagrant up --provision
```

### Syncing code between your local dev environment and vagrant.

A new feature in Vagrant 1.5 is `vagrant rsync` which does away with some of the problems associated with mounted folders.
The ./accelerated_claims folder is copied into /srv/accelerated_claims (inside the VM) when the machine is provisioned. You can resync any local changes using `vagrant rsync` or use the `vagrant rsync-auto` command to watch for changes in your local directory and auto-sync them to the virtual machine.

When the code changes, you will still need to manually restart supervisor jobs inside the VM.

```
vagrant rsync
vagrant ssh -c 'sudo service accelerated-claim-rails restart'
```

Should do the trick.

TODO:
Configure Guard to restart supervisord when code changes. Suggest [https://github.com/guard/guard-shell](https://github.com/guard/guard-shell) might be a good way of doing this.
