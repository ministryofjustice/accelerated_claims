/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.externallinks = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      clickExtLink,

      //elements
      extLinks
      ;

  init = function() {
    cacheEls();
    bindEvents();
  };

  cacheEls = function() {
    extLinks = $( 'a[rel=external]' );
  };

  bindEvents = function() {
    $( extLinks ).on( 'click', function( e ) {
      e.preventDefault();
      clickExtLink( $( e.target ) );
    } );
  };

  clickExtLink = function( $el ) {
    window.open( $el.attr( 'href' ), '_blank' );
  };

  // public

  return {
    init: init
  };

}());
