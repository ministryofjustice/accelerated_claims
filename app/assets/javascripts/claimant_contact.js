/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.claimantContact = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      setupDetailsBlock,

      //elements
      $panel,
      $detailsBlocks
      ;

  init = function() {
    cacheEls();

    $detailsBlocks.each( function() {
      setupDetailsBlock( $( this ) );
    } );
  };

  cacheEls = function() {
    $panel = $( '.claimant-solicitor' );
    $detailsBlocks = $( '.details', $panel );
  };

  setupDetailsBlock = function( $el ) {
    moj.log( $el );

    // var source,
    //     template,
    //     context;

    // source = $( '#hb-yesno' ).html();
    // template = Handlebars.compile( source );
    // context = { question: 'Is the address the same as the first claimant?', id: 'claimant2address', reverse: 'true' };

    // $el.find( '.sub-panel.address' ).addClass( 'rel' ).before( template( context ) ).hide();

    // moj.Modules.jsState.registerField( $( 'input[name=claimant2address]' ) );
  };

  // public

  return {
    init: init
  };

}());
