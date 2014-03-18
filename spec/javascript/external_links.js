var url = casper.cli.get('url');

casper.start(url, function() {
  this.test.comment('Testing external links on landing page');
  this.click('a#find-out-more');
});
casper.waitForPopup('https://www.gov.uk/gaining-possession-of-a-privately-rented-property-let-on-an-assured-shorthold-tenancy', function() {
  this.test.assertEquals(this.popups.length, 1);
});
casper.then(function(){
  this.click('a#notice-to-leave');
});
casper.waitForPopup('https://www.gov.uk/gaining-possession-of-a-privately-rented-property-let-on-an-assured-shorthold-tenancy#seeking-possession-under-section-21', function() {
  this.test.assertEquals(this.popups.length, 2);
});
casper.then(function(){
  this.click('a#pcol');
});
casper.waitForPopup('https://www.possessionclaim.gov.uk/pcol/', function() {
  this.test.assertEquals(this.popups.length, 3);
});
casper.then(function(){
  this.click('a#legal-aid');
});
casper.waitForPopup('https://www.gov.uk/legal-aid', function() {
  this.test.assertEquals(this.popups.length, 4);
});
casper.then(function(){
  this.click('a#advice-guide');
});
casper.waitForPopup('http://www.adviceguide.org.uk', function() {
  this.test.assertEquals(this.popups.length, 5);
});


casper.run(function() {
  this.test.done();
});
