var url = casper.cli.get('url');

casper.start(url, function() {
  this.page.clearCookies();

  this.click( '.action-buttons .button' );
});

casper.wait(500, function() {
  this.test.comment('Testing multiple claimant/defendants');

  this.test.comment('claimants');
  this.test.assertVisible('#multiplePanelSelector_claimants');
  this.test.assertNotVisible('#claimant_2');
  this.evaluate(function(){
    $('#multiplePanelSelector_claimants').val('2').trigger('change');
  });
  this.test.assertVisible('#claimant_2');

  this.test.comment('defendants');
  this.test.assertVisible('#multiplePanelSelector_defendants');
  this.test.assertNotVisible('#defendant_two');
  this.evaluate(function(){
    $('#multiplePanelSelector_defendants').val('2').trigger('change');
  });
  this.test.assertVisible('#defendant_two');

});

casper.run(function() {
  this.test.done();
});
