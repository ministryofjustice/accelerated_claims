var url = casper.cli.get('url');

casper.start(url, function() {
  this.page.clearCookies();

  this.click( '.action-buttons .button' );
});

casper.wait(500, function() {
  this.test.comment('Testing title dropdowns');
  this.test.assertNotExists('input#claim_claimant_one_title');
  this.test.assertExists('select#claim_claimant_one_title');
  this.test.assertNotExists('input#claim_claimant_two_title');
  this.test.assertExists('select#claim_claimant_two_title');
  this.test.assertNotExists('input#claim_defendant_one_title');
  this.test.assertExists('select#claim_defendant_one_title');
  this.test.assertNotExists('input#claim_defendant_two_title');
  this.test.assertExists('select#claim_defendant_two_title');

  this.test.comment('Selecting "other" in dropdowns');
  this.evaluate(function(){
    $('#claim_claimant_one_title').val('other').trigger('change');
    $('#claim_claimant_two_title').val('other').trigger('change');
    $('#claim_defendant_one_title').val('other').trigger('change');
    $('#claim_defendant_two_title').val('other').trigger('change');
  });

  this.test.comment('Testing title text fields');
  this.test.assertExists('input#claim_claimant_one_title');
  this.test.assertNotExists('select#claim_claimant_one_title');
  this.test.assertExists('input#claim_claimant_two_title');
  this.test.assertNotExists('select#claim_claimant_two_title');
  this.test.assertExists('input#claim_defendant_one_title');
  this.test.assertNotExists('select#claim_defendant_one_title');
  this.test.assertExists('input#claim_defendant_two_title');
  this.test.assertNotExists('select#claim_defendant_two_title');

});

casper.run(function() {
  this.test.done();
});
