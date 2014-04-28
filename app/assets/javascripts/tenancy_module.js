/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.tenancyModule = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,

      //elements
      $div
      ;

  init = function() {
    cacheEls();

    $div.addClass( 'inset' ).find( '.inset' ).removeClass( 'inset' ).removeClass( 'sub-panel' );
  };

  cacheEls = function() {
    $div = $( '.assuredTenancyOptions' ).eq( 0 );
  };

  // public

  return {
    init: init
  };

}());
