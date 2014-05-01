/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.selectState = (function() {
  "use strict";

  var //functions
      init,
      bindEvents,
      radioClick,
      radioBlur
      ;

  init = function() {
    bindEvents();
  };

  bindEvents = function() {
    $( document ).on( 'focus', 'fieldset.radio [type="radio"]', function() {
      radioClick( $( this ) );
    } ).on( 'blur', 'fieldset.radio [type="radio"]', function() {
      radioBlur( $( this ) );
    } );
  };

  radioClick = function( $el ) {
    var name = $el.attr( 'name' );

    $( '[name="' + name + '"]' ).closest( 'label' ).removeClass( 'highlight' );
    $el.closest( 'label' ).addClass( 'highlight focus' );
  };

  radioBlur = function( $el ) {
    $el.closest( 'label' ).removeClass( 'focus' );
  };

  // public

  return {
    init: init
  };

}());
