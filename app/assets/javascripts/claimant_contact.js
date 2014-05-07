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

      //elements
      $panel,
      $captions
      ;

  init = function() {
    cacheEls();
    bindEvents();

    hidePanel();
    checkPanel();
  };

  cacheEls = function() {
    $panel = $( '.claimant-solicitor' );
    $captions = $( '.caption', $panel );
  };

  bindEvents = function() {
    $captions.on( 'click', function() {
      toggleDetailsBlock( $( this ).closest( '.details' ) );
    } );

    $( '[name="multiplePanelRadio_claimants"]' ).on( 'click', function() {
      showPanel();
    } );
  };

  toggleDetailsBlock = function( $el ) {
    $el.toggleClass( 'open' );
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
      moj.log( els.length );
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
    init: init
  };

}());
