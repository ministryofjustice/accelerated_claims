var url = casper.cli.get('url');

casper.start(url + '/new', function() {

  casper.test.comment('Testing defendant 1 address show/hide');
  this.test.assertNotVisible('#defendant_one .address');
  this.click('#defendant1address-no');
  this.test.assertVisible('#defendant_one .address');

  casper.test.comment('Testing defendant 2 address show/hide');
  this.test.assertNotVisible('#defendant_two .address');
  this.click('#defendant2address-no');
  this.test.assertVisible('#defendant_two .address');

});

casper.run(function() {
  this.test.done();
});
