/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.claimantContact = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      toggleDetailsBlock,
      showPanel,
      hidePanel,
      checkPanel,
      updateClaimantSolicitorVisibility,

      //elements
      $panel,
      $captions,
      $claimantTypeRadio,
      $numberOfClaimants;

  init = function() {
    cacheEls();
    bindEvents();

    hidePanel();
    checkPanel();
  };

  cacheEls = function() {
    $panel = $( '.claimant-solicitor' );
    $captions = $( '.caption', $panel ).add( '.caption', $( '.address' ) );

    $claimantTypeRadio = $('[name="claim[claimant_type]"]');
    $numberOfClaimants = $('#claim_num_claimants');
  };

  bindEvents = function() {
    $captions.on( 'click', function( e ) {
      e.preventDefault();
      toggleDetailsBlock( $( this ).closest( '.details' ) );
    } );
  };

  updateClaimantSolicitorVisibility = function(){
    var claimantType = moj.Modules.tools.getRadioVal($claimantTypeRadio);
    var isSetNumberOfClaimants = !!$numberOfClaimants.val();

    $panel.toggle(claimantType==='organization' || claimantType==='individual' && isSetNumberOfClaimants);
  };

  toggleDetailsBlock = function( $el ) {
    $el.toggleClass( 'open' );
    if( $el.hasClass( 'open' ) ) {
      $( 'input', $el ).add('textarea', $el).eq( 0 ).trigger( 'focus' );
    }
  };

  hidePanel = function() {
    $panel.add( $panel.prev( '.divider' ) ).hide();
  };

  showPanel = function() {
    $panel.add( $panel.prev( '.divider' ) ).show();
  };

  checkPanel = function() {
    var subPanels = $( '.sub-panel', $panel ),
        x,
        y,
        show,
        els;

    for( x = 0; x < subPanels.length; x++ ) {
      els = $( subPanels[ x ] ).find( '[type="text"], textarea' );
      show = false;
      for( y = 0; y < els.length; y++ ) {
        if( $( els[ y ] ).val() !== '' ) {
          show = true;
        }
      }
      if( show ) {
        $( subPanels[ x ] ).addClass( 'open' );
      }
    }
  };

  // public

  return {
    init: init,
    updateClaimantSolicitorVisibility: updateClaimantSolicitorVisibility
  };

}());
