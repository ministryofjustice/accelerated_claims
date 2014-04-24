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

      //elements
      $panel,
      $captions
      ;

  init = function() {
    cacheEls();
    bindEvents();

    hidePanel();
  };

  cacheEls = function() {
    $panel = $( '.claimant-solicitor' );
    $captions = $( '.caption', $panel );
  };

  bindEvents = function() {
    $captions.on( 'click', function() {
      toggleDetailsBlock( $( this ).closest( '.details' ) );
    } );

    $( 'input[name="multiplePanelRadio_claimants"]' ).on( 'click', function() {
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

  // public

  return {
    init: init
  };

}());
