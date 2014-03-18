var url = casper.cli.get('url');

casper.start(url + '/new', function() {
  this.test.comment('Testing external links on form page');
  this.click('a#giving-notice-link');
});
casper.waitForPopup('https://www.gov.uk/gaining-possession-of-a-privately-rented-property-let-on-an-assured-shorthold-tenancy#seeking-possession-under-section-21', function() {
  this.test.assertEquals(this.popups.length, 1);
});

casper.thenOpen(url + '/confirmation', function() {
  this.test.comment('Testing external link on confirmation page');
  this.click('a.external');
});
casper.waitForPopup('https://courttribunalfinder.service.gov.uk/', function() {
  this.test.assertEquals(this.popups.length, 2);
});

casper.run(function() {
  this.test.done();
});
