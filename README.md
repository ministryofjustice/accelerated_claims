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
rails s
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

The tests themselves live at `/spec/javascript/` and to run them from the command line once Phantom and Casper are installed, run this command from the root of the project:

```
casperjs test ./spec/javascript/
```

If you want to test against the Gecko (Firefox) engine rather than the Webkit (Chrome) engine that PhantomJS uses, you can use SlimerJS as the headless browser.

Install that with:

```
brew install slimerjs
```

Then run casper using the `--engine` switch like so:

```
casperjs test ./spec/javascript/ --engine=slimerjs
```
