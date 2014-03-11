var url = casper.cli.get('url');


casper.start(url, function() {
  this.test.comment('Testing external link on landing page');
  this.click('a.external');
});
casper.waitForPopup('https://www.possessionclaim.gov.uk/pcol/', function() {
    this.test.assertEquals(this.popups.length, 1);
});


casper.thenOpen(url + '/new', function() {
  this.test.comment('Testing external links on form page');
  this.click('a#giving-notice-link');
});
casper.waitForPopup('https://www.gov.uk/gaining-possession-of-a-privately-rented-property-let-on-an-assured-shorthold-tenancy#seeking-possession-under-section-21', function() {
    this.test.assertEquals(this.popups.length, 2);
});
casper.then(function() {
  this.click('a#multiple-occupation-link');
});
casper.waitForPopup('https://www.gov.uk/private-renting/houses-in-multiple-occupation', function() {
    this.test.assertEquals(this.popups.length, 3);
});

casper.thenOpen(url + '/confirmation', function() {
  this.test.comment('Testing external link on confirmation page');
  this.click('a.external');
});
casper.waitForPopup('https://courttribunalfinder.service.gov.uk/', function() {
    this.test.assertEquals(this.popups.length, 4);
});


casper.run(function() {
    this.test.done();
});
