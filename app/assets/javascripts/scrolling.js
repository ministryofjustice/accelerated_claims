/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.scrolling = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      setup,
      bindEvents,

      //elements
      $form
      ;

  init = function() {
    cacheEls();
    bindEvents();

    setup();
  };

  cacheEls = function() {
    $form = $( 'form#claimForm' );
  };

  bindEvents = function() {
    $( window ).scrollStopped( function() {
      var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
      $( '#ypos' ).val( scrollTop ).trigger( 'change' );
    } );
  };

  setup = function() {
    $form.append( '<input type="hidden" id="ypos" name="ypos" />' );
    moj.Modules.jsState.registerField( $( '#ypos' ) );
  };

  // public

  return {
    init: init
  };

}());
