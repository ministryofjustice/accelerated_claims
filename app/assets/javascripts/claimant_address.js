/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.claimantAddress = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      setupAddressBlock,

      //elements
      $addressBlocks
      ;

  init = function() {
    cacheEls();
    bindEvents();

    $addressBlocks.each( function() {
      setupAddressBlock( $( this ) );
    } );
  };

  cacheEls = function() {
    $addressBlocks = $( '.same-address' );
  };

  bindEvents = function() {

  };

  setupAddressBlock = function( $el ) {
    var source,
        template,
        context;

    source = $( '#hb-yesno' ).html();
    template = Handlebars.compile( source );
    context = { question: 'Is the address the same as claimant 1?', id: 'claimant2address', reverse: 'true' };

    $el.find( '.sub-panel.address' ).addClass( 'extra rel' ).before( template( context ) ).hide();
  };

  // public

  return {
    init: init
  };

}());
