# Running the tests

Ensure you have installed all the gems from the 'test' group. (`bundle install --no-deployment --without=none` if you need to).

## Syncing Journey Data

The Journey Data for the feature specs is held externally in a spreadsheet at https://docs.google.com/a/digital.justice.gov.uk/spreadsheet/ccc?key=0Arsa0arziNdndHlwM2xJMVl5Z3pDdFVOYnVsRmZST1E&usp=drive_web#gid=0.  The contents of the data files `spec/fixtures/scenario_1_data.rb` to
`spec/fixtures/scenario_12_data.rb` are generated from this spreadsheet with the `rake fixtures:refresh` task.

Therefore, if the data in these files needs to change, update the spreadsheet and refresh - do not update the scenario data files directly.

## Running the Journey Data

For all the examples below, **XX** is a journey number.

There are two ways of using the Journey Data:

* in the manual tests
* in the automated tests

### Manual test usage

When you wish to populate the form with data, instead of doing it manually, just load:

     http://localhost:3000/?journey=XX

### Automated test usage

The Journey data can be run manually by typing out the full command

    JOURNEY=XX bundle exec rspec spec/features/submit_claim_spec.rb

There is also a Rake command that is easier to remember:

    rake journey:run JOURNEY=XX

If **JOURNEY** is omitted, it will run all the journeys.


## Running the tests locally

Several options:
```
rake # runs all the tests
rspec spec/{folder}/{file} # runs the specified file
guard # watches for changes, runs the minimum set of tests on change
```

## Running the Feature tests against a remote environment

`rake spec:features env=demo browser=chrome`

Where **env** remote options are:

* dev
* demo
* staging
* production

By default, the tests will run headlessly.

If you want to watch your tests run on your desktop, append `browser=[chrome|firefox]` to the command, like `rake spec:features env=production browser=chrome`

To run tests with **browser=chrome**, use chromedriver.

Install chromedriver via homebrew `brew install chromedriver`, otherwise [download](http://chromedriver.storage.googleapis.com/index.html) (we've
tested locally with version 2.9), uncompress and put executable in your path, e.g.
```
cp chromedriver /usr/local/bin
chmod a+x chromedriver
```

## Browserstack remote tests

To run with browser stack:

```
env=<env> BS_USERNAME=<username> BS_PASSWORD=<password> bundle exec rake browserstack:run
```

## Load Testing

Load testing is done through the tsung-wrapper repo.

Tsung cannot cope with sending back Rails CSRF authenticity tokens, so the server has to be run without CSRF protection for loadtesting.  This is
achieved by setting an environment variable CC_NO_CSRF to any value.

## W3C validation tests

These are configured to run each night by Jenkins.

To run them locally on your machine:

```
rake w3c:validate
```

or, to include outputs of the errors:

```
w3c_debug=true rake w3c:validate
```