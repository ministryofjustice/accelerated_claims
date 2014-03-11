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

## Using the Vagrant development environment

There's an experimental VM provisioner to create a local development environment. It's hoped this will be useful as a place to test 
deployment and infrastructure configuration, and to test against the application in a production-like environment.

To get started, you'll need to have [vagrant](http://www.vagrantup.com/) and [virtualbox](https://www.virtualbox.org/) (along with the 'VirtualBox Extension Pack' from the virtualbox download page) installed and access to the config repo.

```
git clone git@github.com:ministryofjustice/accelerated_claims.git
git clone git@github.com:ministryofjustice/civil-claims-deploy.git
git clone <config git repo>
cd accelerated_claims
vagrant up --provision
```
This will take a few minutes, so now's a good time to make a cup of tea. 

Once it finishes, you will be able to see the app landing page on [http://localhost:8080/accelerated](http://localhost:8080/accelerated)

Reprovision using the `vagrant provision` command, or completely rebuild with:
```
vagrant destroy -f
cd ..
cd config; git pull; cd ..
cd civil-claims-deploy; git pull; cd ..
cd accelerated_claims
vagrant up --provision
```


## Production deployment

Please remember to set the environment **SECRET_KEY_BASE** variable.

## JS Functional Tests

The front-end functional testing uses CasperJS running on PhantomJS. Install those with homebrew:

```
brew update
brew install phantomjs
brew install casperjs --devel
```

The tests themselves live at `/spec/javascript/` and to run them from the command line once Phantom and Casper are installed, run this command from the root of the project, passing in the base URL of the app:

```
casperjs test ./spec/javascript/ --url='http://localhost:3000/'
```

If you want to test against the Gecko (Firefox) engine rather than the Webkit (Chrome) engine that PhantomJS uses, you can use SlimerJS as the headless browser.

Install that with:

```
brew install slimerjs
```

Then run casper using the `--engine` switch like so:

```
casperjs test ./spec/javascript/ --url='http://localhost:3000/ --engine=slimerjs
```

TODO: rake task to run the Casper tests.
