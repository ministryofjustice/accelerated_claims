var url = casper.cli.get('url');

casper.start(url + '/new', function() {

  casper.test.comment('Testing claimant 2 address functionality');

  this.test.assertNotVisible('.same-address .address');
  this.click('#claimant2address-no');
  this.test.assertVisible('.same-address .address');

});

casper.run(function() {
  this.test.done();
});
