/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

// Module to replace certain pieces of copy with alternatives or remove them entirely if JS is present

moj.Modules.jsAlt = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      replaceText,

      //elements
      $jsAlts
      ;

  init = function() {
    cacheEls();
    bindEvents();

    $jsAlts.each( function() {
      replaceText( $( this ) );
    } );
  };

  cacheEls = function() {
    $jsAlts = $( '.nonjs' );
  };

  bindEvents = function() {

  };

  replaceText = function( $el ) {
    if( $el.data( 'jsalt' ) ) {
      $el.text( $el.data( 'jsalt' ) );
    } else {
      $el.remove();
    }
  };

  // public

  return {
    init: init
  };

}());
