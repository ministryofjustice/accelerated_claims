var url = casper.cli.get('url');

casper.start(url, function() {
  this.page.clearCookies();

  this.click( '.action-buttons .button' );
});

casper.wait(500, function() {
  casper.test.comment('Testing yes/no question functionality');

  casper.test.comment('Solicitor question');
  this.test.assertNotVisible('.yesno-solicitor');
  this.click('#yesno-solicitor-yes');
  this.test.assertVisible('.yesno-solicitor');

  casper.test.comment('Correspondance question');
  this.test.assertNotVisible('.yesno-correspondance');
  this.click('#yesno-correspondance-yes');
  this.test.assertVisible('.yesno-correspondance');

  casper.test.comment('Contact methods question');
  this.test.assertNotVisible('.yesno-contactmethods');
  this.click('#yesno-contactmethods-yes');
  this.test.assertVisible('.yesno-contactmethods');

  casper.test.comment('Reference number question');
  this.test.assertNotVisible('.yesno-reference');
  this.click('#yesno-reference-yes');
  this.test.assertVisible('.yesno-reference');

});

casper.run(function() {
  this.test.done();
});
