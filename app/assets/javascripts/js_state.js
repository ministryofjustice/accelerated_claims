/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.jsState = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      registerField,
      deRegisterField,
      storeState,
      getValue,
      getType,
      getRadioVal,
      checkState,
      setRadio,
      setSelect,
      setText,

      //elements
      $stateField,

      //data
      watchEls = []
      ;

  init = function() {
    cacheEls();

    checkState();
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

  deRegisterField = function( $el ) {
    var x;

    for( x = 0; x < watchEls.length; x++ ) {
      if( $( watchEls[ x ] ).attr( 'name' ) === $el.attr( 'name' ) ) {
        watchEls = moj.Modules.tools.removeFromArray( watchEls, watchEls[ x ] );
      }
    }
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

    $stateField.val( stateStr );
  };

  getValue = function( $el ) {
    if( $el.is( 'input' ) && $el.attr( 'type' ) === 'radio' ) {
      return getRadioVal( $el );
    }
    
    return $el.val();
  };

  getType = function( $el ) {
    if( $el.is( 'input' ) ) {
      return $el.attr( 'type' );
    }
    if( $el.is( 'select' ) ) {
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

  checkState = function() {
    if( $stateField.length > 0 && $stateField.val() !== '' ) {
      var stateArr = $.parseJSON( $stateField.val() ),
          x;
      
      for( x = 0; x < stateArr.length; x++ ) {
        if( stateArr[ x ].type === 'text' ) {
          setText( stateArr[ x ] );
        } else if( stateArr[ x ].type === 'radio' ) {
          setRadio( stateArr[ x ] );
        } else if( stateArr[ x ].type === 'select' ) {
          setSelect( stateArr[ x ] );
        }
      }
    }
  };

  setRadio = function( obj ) {
    if( obj.value !== 'unchecked' ) {
      $( 'input#' + obj.name + '-' + obj.value ).trigger( 'click' );
    }
  };

  setSelect = function( obj ) {
    $( 'select[name="' + obj.name + '"]' ).val( obj.value ).trigger( 'change' );
  };

  setText = function( obj ) {
    if( obj.name.substr( obj.name.length - 7, obj.name.length ) === '[title]' ) {
      moj.Modules.titleFields.switchToText( $( 'select[name="' + obj.name + '"]' ) );
    }

    $( 'input[name="' + obj.name + '"]' ).val( obj.value );
  };

  // public

  return {
    init: init,
    registerField: registerField,
    deRegisterField: deRegisterField,
    storeState: storeState
  };

}());
