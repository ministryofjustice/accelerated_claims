var url = casper.cli.get('url');

casper.start(url, function() {
  this.page.clearCookies();

  this.click( '.action-buttons .button' );
});

casper.wait(500, function() {
  this.test.comment('Testing JS elements state persistence');

  this.test.comment('Setting all JS-created elements');
  this.evaluate(function(){
    $('#claim_claimant_one_title').val('Mr').trigger('change');
    $('#claim_claimant_two_title').val('Mrs').trigger('change');
    $('#claim_defendant_one_title').val('Miss').trigger('change');
    $('#claim_defendant_two_title').val('other').trigger('change');

    $('#multiplePanelSelector_claimants').val('2').trigger('change');
    $('#multiplePanelSelector_defendants').val('2').trigger('change');
  });

  this.fill('form#claimForm', {
    'claim[defendant_two][title]':  'Reverend'
  });

  this.click( '#claimant2address-no' );
  this.click( '#defendant1address-no' );
  this.click( '#defendant2address-no' );
  this.click( '#yesno-solicitor-yes' );
  this.click( '#yesno-correspondance-yes' );
  this.click( '#yesno-contactmethods-yes' );
  this.click( '#yesno-reference-yes' );
  this.click( '#claim_license_multiple_occupation_yes' );
  this.click( '#claim_deposit_received_yes' );
  this.click( '#claim_deposit_as_property_yes' );

  this.test.comment('Submitting form');
  this.click( '#fakeSubmit' );

  this.test.comment('Waiting 5s for page to reload. There may be a better way of doing this...');
  
  this.wait(5000, function() {
    this.test.comment('Checking the error summary is visible, just to make sure the page has reloaded with errors');
    this.test.assertVisible( 'section.error-summary' );

    this.test.comment('Checking claimant one title');
    this.test.assertField( 'claim[claimant_one][title]', 'Mr' );
    this.test.comment('Checking claimant two title');
    this.test.assertField( 'claim[claimant_two][title]', 'Mrs' );
    this.test.comment('Checking defendant one title');
    this.test.assertField( 'claim[defendant_one][title]', 'Miss' );
    this.test.comment('Checking defendant two title');
    this.test.assertField( 'claim[defendant_two][title]', 'Reverend' );

    this.test.comment('Checking number of claimants');
    this.test.assertField( 'multiplePanelSelector_claimants', '2' );
    this.test.comment('Checking number of defendants');
    this.test.assertField( 'multiplePanelSelector_defendants', '2' );

    this.test.comment('Checking second claimant visible');
    this.test.assertVisible( '#claimant_two' );
    this.test.comment('Checking second defendant visible');
    this.test.assertVisible( '#defendant_two' );

    this.test.comment('Checking second claimant separate address visible');
    this.test.assertVisible( '#claimant_two .sub-panel.address' );
    this.test.comment('Checking first defendant separate address visible');
    this.test.assertVisible( '#defendant_one .sub-panel.address' );
    this.test.comment('Checking second defendant separate address visible');
    this.test.assertVisible( '#defendant_two .sub-panel.address' );

    this.test.comment('Checking legal costs visible');
    this.test.assertVisible( '.sub-panel.yesno-solicitor' );
    this.test.comment('Checking correspondance visible');
    this.test.assertVisible( '.sub-panel.yesno-correspondance' );
    this.test.comment('Checking contact methods visible');
    this.test.assertVisible( '.sub-panel.yesno-contactmethods' );
    this.test.comment('Checking reference number visible');
    this.test.assertVisible( '.sub-panel.yesno-reference' );

    this.test.comment('Checking multiple occupation panel visible');
    this.test.assertVisible( '.sub-panel.js-multiple-occupation' );
    this.test.comment('Checking money deposit panel visible');
    this.test.assertVisible( '.sub-panel.js-money-deposit' );
    this.test.comment('Checking property deposit panel visible');
    this.test.assertVisible( '.row.js-property-deposit' );
  });

});

casper.run(function() {
  this.test.done();
});
