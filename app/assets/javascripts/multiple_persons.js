/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.multiplePersons = (function() {
  "use strict";

  //functions
  var
    init,
    cacheEls,
    bindEvents,
    destroyAll,
    createClaimantBlocks,
    createClaimantBlock,
    updateClaimantBlocks,
    htmlTemplate,

    //elements
    $claimants,
    $numberOfClaimants,
    $claimantBlocks,
    $claimantTypeRadio,

    //other
    maxClaimants = 4;

  init = function() {
    cacheEls();
    bindEvents();
  };

  cacheEls = function() {
    $claimants = $('.claimants');
    $numberOfClaimants = $('#claim_num_claimants');
    $claimantBlocks = $claimants.find('.claimant[data-claimant]');
    htmlTemplate = $('.claimant-template').html();
    $claimantTypeRadio = $('.radio[data-depend=claimanttype] input');
  };

  bindEvents = function() {
    $numberOfClaimants.keyup(function() {
      createClaimantBlocks(parseInt($(this).val(), 10));
    });

    $claimantTypeRadio.change(function() {
      updateClaimantBlocks($(this));
    });
  };

  createClaimantBlocks = function(numberOfBlocks) {
    destroyAll();

    if(isNaN(numberOfBlocks)){ return; }

    if(numberOfBlocks > maxClaimants){
      numberOfBlocks = maxClaimants;
    }

    for(var a=1;a<=numberOfBlocks;a++){
      createClaimantBlock(a);
    }

    $claimantBlocks = $claimants.find('.claimant[data-claimant]');

    if($claimantBlocks.length===1){
      $claimantBlocks.find('h3').hide();
    }

    $(document).trigger('multiplePersons:update', [$claimantTypeRadio]);
  };

  createClaimantBlock = function(blockNumber) {
    var template = Handlebars.compile(htmlTemplate);
    var html = template({id: blockNumber, number: blockNumber});
    $(html).appendTo($claimants);
  };

  destroyAll = function() {
    $claimantBlocks.remove();
  };

  updateClaimantBlocks = function($input) {
    $numberOfClaimants.val('');
    createClaimantBlocks($input.val()==='organization' ? 1 : 0);
  };

  // public
  return {
    init: init,
    createClaimantBlocks: createClaimantBlocks
  };

}());
