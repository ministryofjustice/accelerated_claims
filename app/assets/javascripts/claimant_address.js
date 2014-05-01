/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.claimantAddress = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      setupAddressBlock,

      //elements
      $addressBlocks
      ;

  init = function() {
    cacheEls();

    $addressBlocks.each( function() {
      setupAddressBlock( $( this ) );
    } );
  };

  cacheEls = function() {
    $addressBlocks = $( '.same-address' );
  };

  setupAddressBlock = function( $el ) {
    var source,
        template,
        context;

    source = $( '#hb-yesno' ).html();
    template = Handlebars.compile( source );
    context = { question: 'Is the address the same as the first claimant?', id: 'claimant2address', reverse: 'true' };

    $el.find( '.sub-panel.address' ).addClass( 'rel' ).before( template( context ) ).hide();

    moj.Modules.jsState.registerField( $( '[name=claimant2address]' ) );
  };

  // public

  return {
    init: init
  };

}());
