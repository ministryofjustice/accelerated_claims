var url = casper.cli.get('url');

casper.start(url + '/new', function() {

  this.test.comment('Testing address copying');

  this.fill('form#claimForm', {
    'claim[property][street]':        '123 Property Street',
    'claim[property][town]':          'London',
    'claim[property][postcode]':      'W12 8QT',
    
    'claim[claimant_one][street]':    '22 Acacia Avenue',
    'claim[claimant_one][town]':      'Birmingham',
    'claim[claimant_one][postcode]':  'B15 2TT'
  });

  this.click( '#claimant2address-yes' );
  this.click( '#defendant1address-yes' );
  this.click( '#defendant2address-yes' );

  this.click( '#fakeSubmit' );

  this.test.assertField('claim[defendant_one][street]', '123 Property Street');
  this.test.assertField('claim[defendant_one][town]', 'London');
  this.test.assertField('claim[defendant_one][postcode]', 'W12 8QT');

  this.test.assertField('claim[defendant_two][street]', '123 Property Street');
  this.test.assertField('claim[defendant_two][town]', 'London');
  this.test.assertField('claim[defendant_two][postcode]', 'W12 8QT');

  this.test.assertField('claim[claimant_two][street]', '22 Acacia Avenue');
  this.test.assertField('claim[claimant_two][town]', 'Birmingham');
  this.test.assertField('claim[claimant_two][postcode]', 'B15 2TT');
});

casper.run(function() {
  this.test.done();
});
