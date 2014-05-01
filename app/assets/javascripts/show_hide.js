/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.showHide = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      chooseOption,

      //elements
      radios
      ;

  init = function() {
    cacheEls();
    bindEvents();

    radios.each( function() {
      moj.Modules.jsState.registerField( $( this ) );
    } );
  };

  cacheEls = function() {
    radios = $( '.js-depend [type=radio]' );
  };

  bindEvents = function() {
    $( radios ).on( 'click', function( e ) {
      chooseOption( $( e.target ) );
    } );
  };

  chooseOption = function( $el ) {
    var clickValue = $el.val().toLowerCase(),
        dependGroup = $el.closest( '.js-depend' ).data( 'depend' ),
        $groupEls = $( '.js-' + dependGroup );

    $groupEls.hide();
    $groupEls.filter( '.' + clickValue ).show();
  };

  // public

  return {
    init: init
  };

}());
