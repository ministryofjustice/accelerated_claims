/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */

moj.Modules.multiplePersons = (function(moj, $, Handlebars) {
  "use strict";

  //functions
  var
    init,
    cacheEls,
    bindEvents,
    createClaimantBlocks,
    createClaimantBlock,
    updateClaimantBlocks,
    htmlTemplate,
    idFix,
    destroyAll,

    //elements
    $claimants,
    $numberOfClaimants,
    $claimantBlocks,
    $claimantTypeRadio,
    $claimantSolicitor,

    //other
    claimantData,
    maxClaimants = 4;

  init = function() {
    cacheEls();
    bindEvents();
    destroyAll();
  };

  cacheEls = function() {
    htmlTemplate = $('.claimant-template').html();
    $claimants = $('.claimants');
    $numberOfClaimants = $('#claim_num_claimants');
    $claimantBlocks = $claimants.find('.claimant');
    $claimantTypeRadio = $('[name="claim[claimant_type]"]');
    $claimantSolicitor = $('.claimant-solicitor');
  };

  bindEvents = function() {
    $numberOfClaimants.keyup(function() {
      createClaimantBlocks(parseInt($(this).val(), 10));
      moj.Modules.claimantContact.updateClaimantSolicitorVisibility();
    });

    $claimantTypeRadio.change(function() {
      updateClaimantBlocks();
      moj.Modules.claimantContact.updateClaimantSolicitorVisibility();
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

  updateClaimantBlocks = function() {
    createClaimantBlocks(moj.Modules.tools.getRadioVal($claimantTypeRadio)==='organization' ? 1 : $numberOfClaimants.val());
  };

  /**
   * There seems to be a bug in labelling form builder: when you specify an id for a text field
   * (using text_field_row), the "for" attribute on its label doesn't correspond to that ID.
   * The following is a temporary fix until the issue with the form builder is resolved.
   * Then we can use handlebars {{id}} and we can delete this function below.
   */
  idFix = function($block, blockNumber){
    $block.find('input').each(function(){
      $(this).attr('id', $(this).attr('id').replace('__id__', blockNumber));
    });

    $block.find('label').each(function(){
      $(this).attr('for', $(this).attr('for').replace('__id__', blockNumber));
    });
  };

  destroyAll = function(){
    $claimantBlocks.remove();
  };

  // public
  return {
    init: init,
    createClaimantBlocks: createClaimantBlocks
  };

}(window.moj, window.$, window.Handlebars));
