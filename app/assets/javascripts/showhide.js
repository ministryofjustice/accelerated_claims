/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.showhide = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      chooseOption,
      showPreChecked,

      //elements
      radios
      ;

  init = function() {
    cacheEls();
    bindEvents();
    showPreChecked();
  };

  cacheEls = function() {
    radios = $( '.js-depend input[type=radio]' );
  };

  bindEvents = function() {
    $( radios ).on( 'click', function( e ) {
      chooseOption( $( e.target ) );
    } );
  };

  chooseOption = function( $el ) {
    var clickValue = $el.val().toLowerCase(),
        showValue = $el.closest( '.js-depend' ).data( 'show' ),
        showElClass = $el.closest( '.js-depend' ).data( 'depend' ),
        $showEls = $( '.js-' + showElClass );

    if( clickValue === showValue ) {
      $showEls.show();
    } else {
      $showEls.hide();
    }
  };

  showPreChecked = function() {
    $( radios ).each( function() {
      var $this = $( this );
      if( $this.is( ':checked' ) ) {
        $this.click();
      }
    } );
  };

  // public

  return {
    init: init
  };

}());
