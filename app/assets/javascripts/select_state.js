/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.selectState = (function() {
  "use strict";

  var //functions
      init,
      bindEvents,
      radioClick,
      elementBlur,
      checkboxClick
      ;

  init = function() {
    bindEvents();
  };

  bindEvents = function() {
    $( document ).on( 'focus', '.option [type="radio"]', function() {
      radioClick( $( this ) );
    } ).on( 'blur', '.option [type="radio"]', function() {
      elementBlur( $( this ) );
    } ).on( 'click', '.option [type="checkbox"]', function() {
      checkboxClick( $( this ) );
    } ).on( 'blur', '.option [type="checkbox"]', function() {
      elementBlur( $( this ) );
    } );

    $( ':checked' ).closest( 'label' ).addClass( 'highlight' );
  };

  radioClick = function( $el ) {
    var name = $el.attr( 'name' );

    $( '[name="' + name + '"]' ).closest( 'label' ).removeClass( 'highlight' );
    $el.closest( 'label' ).addClass( 'highlight focus' );
  };

  checkboxClick = function( $el ) {
    $el.closest( 'label' ).addClass( 'focus' );
    if( $el.is( ':checked' ) ) {
      $el.closest( 'label' ).addClass( 'highlight' );
    } else {
      $el.closest( 'label' ).removeClass( 'highlight' );
    }
  };

  elementBlur = function( $el ) {
    $el.closest( 'label' ).removeClass( 'focus' );
  };

  // public

  return {
    init: init
  };

}());
