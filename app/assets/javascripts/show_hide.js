/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.showHide = (function() {
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
        dependGroup = $el.closest( '.js-depend' ).data( 'depend' ),
        $groupEls = $( '.js-' + dependGroup );

    $groupEls.hide();
    $groupEls.filter( '.' + clickValue ).show();
  };

  showPreChecked = function() {
    // TODO: remove this once state saving is working - there are no pre-checked by default buttons
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
