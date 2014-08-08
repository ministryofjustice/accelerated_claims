/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */

moj.Modules.multiplePersons = (function(moj, $, Handlebars) {
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
    idFix,

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
    destroyAll();
  };

  cacheEls = function() {
    $claimants = $('.claimants');
    $numberOfClaimants = $('#claim_num_claimants');
    $claimantBlocks = $claimants.find('.claimant');
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

    $claimantBlocks = $claimants.find('.claimant');

    if($claimantBlocks.length===1){
      $claimantBlocks.find('h3').hide();
    }

    $(document).trigger('multiplePersons:update', [$claimantTypeRadio]);
  };

  createClaimantBlock = function(blockNumber) {
    var template = Handlebars.compile(htmlTemplate);
    var html = template({id: blockNumber, number: blockNumber});
    var $block = $(html);
    $block.appendTo($claimants);
    idFix($block, blockNumber);
  };

  /**
   * There seems to be a bug in labelling form builder: when you specify an id for a text field
   * (using text_field_row), the "for" attribute on its label doesn't correspond to that ID.
   * The following is a temporary fix until the issue is resolved.
   */
  idFix = function($block, blockNumber){
    $block.find('input').each(function(){
      $(this).attr('id', $(this).attr('id').replace('__id__', blockNumber));
    });

    $block.find('label').each(function(){
      $(this).attr('for', $(this).attr('for').replace('__id__', blockNumber));
    });
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

}(window.moj, window.$, window.Handlebars));
