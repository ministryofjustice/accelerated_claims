var sitename = 'Civil Claims',
    url = 'http://localhost:3000/';


casper.start(url, function() {

  casper.test.comment('Testing site basics');

  this.test.assert(
    this.getCurrentUrl() === url, 'url is the one expected'
  );

  this.test.assertHttpStatus(200, sitename + ' is up');

  this.test.assertTitle(
    'Property repossession - Civil Claims',
    sitename + ' has the correct title'
  );
  
});

casper.run(function() {
    this.test.done();
});
