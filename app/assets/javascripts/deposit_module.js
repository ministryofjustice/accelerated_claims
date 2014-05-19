/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.depositModule = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      depositRadioClick,

      //elements
      $module,
      $depositRadios,
      $depositCheckboxes
      ;

  init = function() {
    cacheEls();
    bindEvents();
  };

  cacheEls = function() {
    $module = $( '#deposit-module' );
    $depositRadios = $( '[name="claim[deposit][received]"]', $module );
    $depositCheckboxes = $( '[type="checkbox"]', $module );
  };

  bindEvents = function() {
    $depositRadios.on( 'click', function( e ) {
      depositRadioClick( $( e.target ) );
    } );
  };

  depositRadioClick = function( $el ) {
    if( $el.val().toLowerCase() === 'no' ) {
      $depositCheckboxes.filter( ':checked' ).trigger( 'click' ).trigger( 'blur' );
      $( 'input[type="text"]', $module ).val( '' );
    }
  };

  // public

  return {
    init: init
  };

}());
