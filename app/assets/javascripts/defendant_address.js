/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.defendantAddress = (function() {
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

    $addressBlocks.each( function( n ) {
      setupAddressBlock( $( this ), n );
    } );
  };

  cacheEls = function() {
    $addressBlocks = $( '.defendant .address' );
  };

  bindEvents = function() {

  };

  setupAddressBlock = function( $el, n ) {
    var source,
        template,
        context;

    source = $( '#hb-yesno' ).html();
    template = Handlebars.compile( source );
    context = { question: 'Are they living in the property?', id: 'defendant' + ( n + 1 ) + 'address', req: 'true', reverse: 'true' };

    $el.before( template( context ) ).addClass( 'rel' ).hide().find( '.caption' ).remove();
  };

  // public

  return {
    init: init
  };

}());
