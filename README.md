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



## Load Testing (Under construction)

Load testing is performed by:

    rake load_test:run

### Tsung_wrapper

The tsung_wrapper project must be checked out of git and installed on the same machine that is running the load test.
The scenarios to run are defined in the tsung_wrapper project, in the ```config/<project_name>``` directory.



