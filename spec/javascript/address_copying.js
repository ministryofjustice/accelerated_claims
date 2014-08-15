var url = casper.cli.get('url');

casper.start(url, function() {
  this.page.clearCookies();

  this.click( '.action-buttons .button' );
});

casper.wait(500, function() {
  this.test.comment('Testing address copying');

  this.fill('form#claimForm', {
    'claim[property][street]':        '123 Property Street',
    'claim[property][town]':          'London',
    'claim[property][postcode]':      'W12 8QT',
    
    'claim[claimant_1][street]':    '22 Acacia Avenue',
    'claim[claimant_1][town]':      'Birmingham',
    'claim[claimant_1][postcode]':  'B15 2TT'
  });

  this.click( '#claimant2address-yes' );
  this.click( '#claim_defendant_one_inhabit_property_yes' );
  this.click( '#claim_defendant_two_inhabit_property_yes' );

  this.click( '#fakeSubmit' );

  this.test.assertField('claim[defendant_one][street]', '123 Property Street');
  this.test.assertField('claim[defendant_one][town]', 'London');
  this.test.assertField('claim[defendant_one][postcode]', 'W12 8QT');

  this.test.assertField('claim[defendant_two][street]', '123 Property Street');
  this.test.assertField('claim[defendant_two][town]', 'London');
  this.test.assertField('claim[defendant_two][postcode]', 'W12 8QT');

  this.test.assertField('claim[claimant_2][street]', '22 Acacia Avenue');
  this.test.assertField('claim[claimant_2][town]', 'Birmingham');
  this.test.assertField('claim[claimant_2][postcode]', 'B15 2TT');
});

casper.run(function() {
  this.test.done();
});
