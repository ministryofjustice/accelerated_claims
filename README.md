# Accelerated Claim app

[![Build Status](http://jenkins.dsd.io/view/Civil%20Claims%20Dashboard/job/civilclaims-accelerated-test/badge/icon)](http://ec2-54-194-212-120.eu-west-1.compute.amazonaws.com/view/Civil%20Claims%20Dashboard/job/civilclaims-accelerated-test/)

[![Code Climate](https://codeclimate.com/github/ministryofjustice/accelerated_claims/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/accelerated_claims)

[![Test Coverage](https://codeclimate.com/github/ministryofjustice/accelerated_claims/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/accelerated_claims)

This is the source code of what is currently a minimum viable product for the Civil Claims exemplar. The application consists in a single form that claimants of accelerated claims fill out to download a PDF. The PDF is the standard accelerated claim form from HMCTS, is filled out with the details that the claimant has provided, and can be signed and sent by post.

## Local setup

Install the following:

* PhantomJS - `brew install phantomjs`
* pdftk server - download from <https://www.pdflabs.com/tools/pdftk-server/>
* Redis - `brew install redis` (optional)

Configuration data is loaded from the .env file (via dotenv gem). The default configuration will work for local development, but see the file for optional variables.

Install the bundle, then start the rails server and PDF strike through service:

```
bundle install
foreman start
```

See the `Procfile` for individual startup invocations.

## Additional documentation

* [Vagrant setup](docs/vagrant.md)
* [Testing](docs/testing.md)

## Production deployment

Please remember to set the environment **SECRET_KEY_BASE** variable.



# Dockerisation

## Introduction

Stephen Richards and Mike Pountney are working on dockerizing this app in order to provide a standardised environment for development, deployment and production running.

## Development environment

The development environment uses Virtual Box and Vagrant to create a linux vm in which to run the docker container.  The Vagrantfile and Dockerfile in this project contain all the instructions necessary to provision the vm, create and run the docker container, and run the app inside the container.

### Setting up the VM and docker container

	vagrant up

The app runs on port 3000 inside the container, which is exposed to the outside world as port 3002 on localhost, therefore to see your app running, navigate to http://localhost:3002



### Running tests on the app running in the container

Unit, lib, routing and controller specs can, and should, be run inside the container.  There is a rake task ```spec:docker``` set up to do this:

	vagrant ssh 			                 # ssh into the virtual machine
	docker ps 				                 # get the container id of the docker container running in the virtual machine
	docker exec -i -t <container_id> bash    # get an interactive shell inside the docker container
	rake spec:docker                         # run all the tests in ```spec/lib spec/models spec/routing spec/controllers```

Feature tests should be run on localhost (the docker container doesn't have phantomjs installed, so the feature tests can't be run from there).


### Dependencies
* Virtual Box  - install from https://www.virtualbox.org/wiki/Downloads
* Vagrant - install from http://www.vagrantup.com/downloads.html




