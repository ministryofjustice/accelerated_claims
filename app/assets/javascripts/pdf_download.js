/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.externallinks = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      clickPdfLink,

      //elements
      $pdfLink
      ;

  init = function() {
    cacheEls();
    bindEvents();
  };

  cacheEls = function() {
    $pdfLink = $( 'a.pdf-download' );
  };

  bindEvents = function() {
    $pdfLink.on( 'click', function( e ) {
      e.preventDefault();
      clickPdfLink( $( e.target ) );
    } );
  };

  clickPdfLink = function( $el ) {
    window.open( $el.attr( 'href' ), '_blank' );
  };

  // public

  return {
    init: init
  };

}());
