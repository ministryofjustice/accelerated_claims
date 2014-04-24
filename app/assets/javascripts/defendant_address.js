/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.defendantAddress = (function() {
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

    $addressBlocks.each( function( n ) {
      setupAddressBlock( $( this ), n );
    } );
  };

  cacheEls = function() {
    $addressBlocks = $( '.defendant .address' );
  };

  setupAddressBlock = function( $el, n ) {
    var source,
        template,
        context;

    source = $( '#hb-yesno' ).html();
    template = Handlebars.compile( source );
    context = { question: 'Is the defendant living in the property?', id: 'defendant' + ( n + 1 ) + 'address', reverse: 'true' };

    $el.before( template( context ) ).addClass( 'rel' ).hide().find( '.caption' ).remove();

    moj.Modules.jsState.registerField( $( 'input[name=defendant' + ( n + 1 ) + 'address]' ) );
  };

  // public

  return {
    init: init
  };

}());
