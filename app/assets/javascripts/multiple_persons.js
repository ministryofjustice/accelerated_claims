/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */

moj.Modules.multiplePersons = (function(moj, $, Handlebars) {
  "use strict";

  var
    //functions
    init,
    cacheEls,
    bindEvents,
    createClaimantBlocks,
    createClaimantBlock,
    updateClaimantBlocks,
    idFix,
    hideAll,

    //elements
    $claimants,
    $numberOfClaimants,
    $claimantBlocks,
    $claimantTypeRadio,

    //other
    htmlTemplate,
    config = {
      maxClaimants: 4
    };

  init = function() {
    cacheEls();
    bindEvents();
    createClaimantBlocks();
  };

  cacheEls = function() {
    htmlTemplate = $('.claimant-template').html();
    $claimants = $('.claimants');
    $numberOfClaimants = $('#claim_num_claimants');
    $claimantBlocks = $claimants.find('.claimant');
    $claimantTypeRadio = $('[name="claim[claimant_type]"]');
  };

  bindEvents = function() {
    $numberOfClaimants.on('keyup blur', function() {
      updateClaimantBlocks();
      moj.Modules.claimantContact.updateClaimantSolicitorVisibility();
    });

    $claimantTypeRadio.change(function() {
      updateClaimantBlocks();
      moj.Modules.claimantContact.updateClaimantSolicitorVisibility();
    });
  };

  /** Creates all claimant blocks
   */
  createClaimantBlocks = function() {
    var a;

    $claimantBlocks.remove(); //destroy all existing blocks (they're only used for non-js)

    for(a=1; a<=config.maxClaimants; a++){
      createClaimantBlock(a);
    }

    $claimantBlocks = $claimants.find('.claimant'); //update the cached claimant blocks
    $claimantBlocks.hide();
  };

  /** Creates a single claimant block
   * @param {Number} blockNumber The number of block
   */

  createClaimantBlock = function(blockNumber) {
    var template = Handlebars.compile(htmlTemplate);
    var html = template({id: blockNumber, number: blockNumber});
    var $block = $(html);

    $block.appendTo($claimants);
    idFix($block, blockNumber);
  };

  /** Updates the visibility of claimant blocks to correspond to the number of claimants entered and the landlord type
   */
  updateClaimantBlocks = function() {
    var numberOfBlocks;
    var landlordType = moj.Modules.tools.getRadioVal($claimantTypeRadio);

    hideAll();

    numberOfBlocks = landlordType==='organization' ? 1 : parseInt($numberOfClaimants.val(), 10);

    if(isNaN(numberOfBlocks)){
      return;
    }

    if(numberOfBlocks > config.maxClaimants){
      numberOfBlocks = config.maxClaimants;
    }

    $claimantBlocks.filter(':lt('+numberOfBlocks+')').show();

    $claimantBlocks.eq(0).find('h3').toggle(numberOfBlocks!==1);

    $(document).trigger('multiplePersons:update', [$claimantTypeRadio]);
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

  /** Hides all claimant blocks
   */
  hideAll = function(){
    $claimantBlocks.hide();
  };

  // public
  return {
    init: init
  };

}(window.moj, window.$, window.Handlebars));
