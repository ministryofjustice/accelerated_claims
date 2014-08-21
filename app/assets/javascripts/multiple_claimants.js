/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */

moj.Modules.multipleClaimants = (function(moj, $, Handlebars){
  "use strict";

  var
    //functions
    init,
    cacheEls,
    bindEvents,
    updateClaimantBlocks,
    hideAll,
    personGenerator,

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

  init = function(){
    cacheEls();
    bindEvents();
    personGenerator = moj.Helpers.personGenerator($claimants, htmlTemplate, config.maxClaimants);
    personGenerator.createPersonBlocks();
    $claimantBlocks = $claimants.find('.claimant'); //cache the newly generated claimant blocks
  };

  cacheEls = function(){
    htmlTemplate = $('.claimant-template').html();
    $claimants = $('.claimants');
    $numberOfClaimants = $('#claim_num_claimants');
    $claimantBlocks = $claimants.find('.claimant');
    $claimantTypeRadio = $('[name="claim[claimant_type]"]');
  };

  bindEvents = function(){
    console.log("binding evenets");
    $numberOfClaimants.on('keyup blur', function(){
      updateClaimantBlocks();
      moj.Modules.claimantContact.updateClaimantSolicitorVisibility();
    });

    $claimantTypeRadio.change(function(){
      updateClaimantBlocks();
      moj.Modules.claimantContact.updateClaimantSolicitorVisibility();
    });
  };

  /** Updates the visibility of claimant blocks to correspond to the number of claimants entered and the landlord type
   */
  updateClaimantBlocks = function(){
    console.log("updateClaimantBlocks");
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
    console.log("NUmber of Blocks: " + numberOfBlocks);
    $claimantBlocks.filter(':lt('+numberOfBlocks+')').show();

    $claimantBlocks.eq(0).find('h3').toggle(numberOfBlocks!==1);

    $(document).trigger('multiplePersons:update', [$claimantTypeRadio]);
  };

  /** Hides all claimant blocks
   */
  hideAll = function(){
    console.log("hideAll");
    $claimantBlocks.hide();
  };

  // public
  return {
    init: init
  };

}(window.moj, window.$, window.Handlebars));
