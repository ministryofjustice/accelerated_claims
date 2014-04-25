/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.tenancyModule = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,

      //elements
      $div
      ;

  init = function() {
    cacheEls();
    bindEvents();

    moj.log( 'uhhh' );

    $div.addClass( 'inset' ).find( '.inset' ).removeClass( 'inset' ).removeClass( 'sub-panel' );
  };

  cacheEls = function() {
    $div = $( '.assuredTenancyOptions' ).eq( 0 );
  };

  bindEvents = function() {

  };

  // public

  return {
    init: init
  };

}());
