var url = casper.cli.get('url');

casper.start(url + '/new', function() {

  casper.test.comment('Testing show/hide functionality');

  casper.test.comment('.js-multiple-occupation');
  this.test.assertNotVisible('.js-multiple-occupation');
  this.click('#claim_license_multiple_occupation_yes');
  this.test.assertVisible('.js-multiple-occupation');

  casper.test.comment('.js-money-deposit');
  this.test.assertNotVisible('.js-money-deposit');
  this.click('#claim_deposit_received_yes');
  this.test.assertVisible('.js-money-deposit');

  casper.test.comment('.js-property-deposit');
  this.test.assertNotVisible('.js-property-deposit');
  this.click('#claim_deposit_as_property_yes');
  this.test.assertVisible('.js-property-deposit');

});

casper.run(function() {
  this.test.done();
});
