/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.showHide = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      chooseOption,
      cbClick,

      //elements
      radios,
      cbs
      ;
  init = function() {
    cacheEls();
    bindEvents();

    radios.each( function() {
      moj.Modules.jsState.registerField( $( this ) );
    } );
    cbs.each( function() {
      moj.Modules.jsState.registerField( $( this ) );
    } );
  };

  cacheEls = function() {
    radios = $( '.js-depend [type=radio]' );
    cbs = $( '.js-depend [type=checkbox]' );
  };

  bindEvents = function() {
    $(document).on('multiplePersons:update', function(e, $element){
      chooseOption($element);
    });

    $( radios ).on( 'change', function( e ) {
      chooseOption( $( e.target ) );
    } );
    $( cbs ).on( 'change', function( e ) {
      cbClick( $( e.target ) );
    } );
  };

  chooseOption = function( $el ) {
    if($el.length>1){
      $el = $el.filter(':checked');
    }

    var clickValue = $el.val().toLowerCase(),
        dependGroup = $el.closest( '.js-depend' ).data( 'depend' ),
        $groupEls = $( '.js-' + dependGroup );

    moj.Modules.animate.showhide( $groupEls, $el, 'hide' );
    if( $groupEls.filter( '.' + clickValue ).length > 0 ) {
      moj.Modules.animate.showhide( $groupEls.filter( '.' + clickValue ), $el, 'show' );
    }
  };

  cbClick = function( $el ) {
    var dependGroup = $el.data( 'depend' ),
        $groupEls = $( '.js-' + dependGroup );

    if( $el.is( ':checked' ) ) {
      moj.Modules.animate.showhide( $groupEls, $el, 'show' );
    } else {
      moj.Modules.animate.showhide( $groupEls, $el, 'hide' );
    }
  };

  // public

  return {
    init: init
  };

}());
