/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.jsState = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      registerField,
      storeState,
      getValue,
      getType,
      getRadioVal,

      //elements
      $stateField,

      //data
      watchEls = []
      ;

  init = function() {
    cacheEls();
  };

  cacheEls = function() {
    $stateField = $( '#js-state' );
  };

  registerField = function( $el ) {
    watchEls[ watchEls.length ] = $el;
    $el.on( 'change', function() {
      storeState();
    } );
  };

  storeState = function() {
    var x,
        obj,
        arr = [],
        stateStr;

    for( x = 0; x < watchEls.length; x++ ) {
      obj = {
        name:   $( watchEls[ x ] ).attr( 'name' ),
        type:   getType( $( watchEls[ x ] ) ),
        value:  getValue( $( watchEls[ x ] ) )
      };
      arr[ arr.length ] = obj;
    }

    stateStr = JSON.stringify( arr );
    moj.log( stateStr );

    $stateField.val( stateStr );

    var $f = $( 'form' ).eq( 0 ),
        a = $f.attr( 'action' );

    $f.attr( 'action', a + '?one=two' );
  };

  getValue = function( $el ) {
    if( $el.is( 'input' ) && $el.attr( 'type' ) === 'radio' ) {
      return getRadioVal( $el );
    } else {
      return $el.val();
    }
  };

  getType = function( $el ) {
    if( $el.is( 'input' ) ) {
      return $el.attr( 'type' );
    } else if( $el.is( 'select' ) ) {
      return 'select';
    }
  };

  getRadioVal = function ( $el ) {
    var radioVal = 'unchecked',
        x;

    for( x = 0; x < $el.length; x++ ) {
      if( $( $el[x] ).is( ':checked' ) ) {
        radioVal = $( $el[x] ).val();
      }
    }

    return radioVal;
  };

  // public

  return {
    init: init,
    registerField: registerField
  };

}());
