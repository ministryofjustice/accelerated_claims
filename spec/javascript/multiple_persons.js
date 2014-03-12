var url = casper.cli.get('url');

casper.start(url + '/new', function() {

  this.test.comment('Testing multiple claimant/defendants');

  this.test.comment('claimants');
  this.test.assertVisible('#multiplePanelSelector_claimants');
  this.test.assertNotVisible('#claimant_two');
  this.evaluate(function(){
    $('#multiplePanelSelector_claimants').val('2').trigger('change');
  });
  this.test.assertVisible('#claimant_two');

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
