# Accelerated Claim app

[![Build Status](http://jenkins.dsd.io/view/Civil%20Claims%20Dashboard/job/civilclaims-accelerated-test/badge/icon)](http://ec2-54-194-212-120.eu-west-1.compute.amazonaws.com/view/Civil%20Claims%20Dashboard/job/civilclaims-accelerated-test/)

This is the source code of what is currently a minimum viable product for the Civil Claims exemplar. The application consists in a single form that claimants of accelerated claims fill out to download a PDF. The PDF is the standard accelerated claim form from HMCTS, is filled out with the details that the claimant has provided, and can be signed and sent by post.

## Local setup

Install **pdftk** & then:

```
git clone https://github.com/ministryofjustice/accelerated_claim.git
cd accelerated_claim
bundle install
export PDFTK=$(which pdftk)
export REDIS_STORE=redis://localhost:6379/1

export ZENDESK_USERNAME=[username]
export ZENDESK_TOKEN=[token]
export ANONYMOUS_PLACEHOLDER_EMAIL=[noreply-email]
rails s
```

You also need to run the PDF strike through service:

```
java -jar scripts/strike2-0.*.0-standalone.jar
```


## Using the Vagrant development environment

There's an experimental VM provisioner to create a local development environment. It's hoped this will be useful as a place to test
deployment and infrastructure configuration, and to test against the application in a production-like environment.

To get started, you'll need to have [vagrant](http://www.vagrantup.com/) and [virtualbox](https://www.virtualbox.org/) (along with the 'VirtualBox Extension Pack' from the virtualbox download page) installed and access to the config repo.
The configuration uses a new feature of Vagrant 1.5, so to make it work you need to ensure that you have the correct version of Vagrant installed. Run `vagrant -v` in your console, and if the result shows `Vagrant 1.4.3` or any other number below 1.5.0 then please follow the installation steps above to get the latest version.

```
echo "192.168.33.10   civilclaims.local" | sudo tee -a  /etc/hosts
git clone git@github.com:ministryofjustice/accelerated_claims.git
git clone git@github.com:ministryofjustice/civil-claims-deploy.git
git clone <config git repo>
cd accelerated_claims
vagrant up --provision
```
This will take a few minutes, so now's a good time to make a cup of tea.

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
vagrant ssh -c "sudo supervisorctl reload all"
```

Should do the trick.

TODO:
Configure Guard to restart supervisord when code changes. Suggest [https://github.com/guard/guard-shell](https://github.com/guard/guard-shell) might be a good way of doing this.

## Running the tests

Ensure you have installed all the gems from the 'test' group. (`bundle install --no-deployment --without=none` if you need to).


### Synching Jouney Data

The Journey Data for the feature specs is held externally in a spreadsheet at https://docs.google.com/a/digital.justice.gov.uk/spreadsheet/ccc?key=0Arsa0arziNdndHlwM2xJMVl5Z3pDdFVOYnVsRmZST1E&usp=drive_web#gid=0.  The contents of the data files ```spec/fixtures/scenario_1_data.rb``` to 
```spec/fixtures/scenario_12_data.rb``` are generated from this spreadsheet with the ```rake fixtures:refresh``` task.

Therefore, if the data in these files needs to change, update the spreadsheet and refresh - so not update the scenario data files directly.






### Running the tests locally

Several options:
```
rake # runs all the tests
rspec spec/{folder}/{file} # runs the specified file
guard # watches for changes, runs the minimum set of tests on change
```

### Running the Feature tests against a remote environment

`rake spec:features env=demo browser=chrome`

Where **env** remote options are:

* dev
* demo
* staging
* production

By default, the tests will run headlessly.

If you want to watch your tests run on your desktop, append `browser=[chrome|firefox]` to the command, like `rake spec:features env=production browser=chrome`

To run tests with **browser=chrome**, [download chromedriver](http://chromedriver.storage.googleapis.com/index.html) we've
tested locally with version 2.9. Uncompress download and put chromedriver executable in your path,
e.g.
cp chromedriver /usr/local/bin
chmod a+x chromedriver

Or just install via homebrew if on OS X: `brew install chromedriver`.

## Browserstack remote tests

To run with browser stack:

```
env=<env> BS_USERNAME=<username> BS_PASSWORD=<password> bundle exec rake browserstack:run
```

## Production deployment

Please remember to set the environment **SECRET_KEY_BASE** variable.


## Load Testing

Load testing is done through the tsung-wrapper repo.

Tsung cannot cope with sending back Rails CSRF authenticity tokens, so the server has to be run without CSRF protection for loadtesting.  This is 
acheived by setting an environment variable CC_NO_CSRF to '1'.  Setting this environment variable in production environment has no effect.


