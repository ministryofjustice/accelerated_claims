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
      checkState,
      setCheckbox,
      setRadio,
      setSelect,
      setText,
      setScroll,
      focusRadios,
      bindEvents,
      findInput,

      //elements
      $stateField,

      //data
      watchEls = []
      ;

  init = function() {
    cacheEls();

    // DISCLAIMER: The approach of passing about js-state appears to be bad; suggestion - moved all data into the model and remove js-state.
    //
    // This call to checkState uses the form_data populated with the page to
    // fill in js-only fields
    checkState();

    focusRadios();
    moj.Modules.tenancyModule.checkDates();

    bindEvents();

    if ( window.location.hash === "" ) {
      window.scrollTo( 0, 0 );
    } else {
      window.location.hash=window.location.hash; // resets location after show/hides
    }

    // Trigger a change on the form in order for the js-state to be filled
    // (which is required for checkState to work correctly)
    $( '#ypos' ).trigger( 'change' );
    checkState();

    // finally, make sure the focus is on the error summary if there are any errors.
    ErrorFocusModule.focusOnErrorSection();
  };

  bindEvents = function() {

    $('.error-link').on( 'click', function() {
      var id = $( this ).attr('data-id');
      var input = findInput(id);

      if( input.size() > 0) {
        input.focus();
      }
    } );
  };

  findInput = function(id) {
    var input = $(id).find( 'textarea:visible' ).eq(0);

    if( input.size() === 0 ) {
      input = $(id).find( 'input:visible' ).eq(0);
    }

    if( input.size() === 0 ) {
      input = $(id).find( 'select:visible' ).eq(0);
    }

    if( input.size() === 0 ) {
      input = $(id).parent().find( 'input:visible' ).eq(0);
    }

    if( input.size() === 0 ) {
      input = $(id).parent().find( 'select:visible' ).eq(0);
    }

    return input;
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
        id:   $( watchEls[ x ] ).attr( 'id' ),
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
      return moj.Modules.tools.getRadioVal( $el );
    } else if( $el.is( 'input' ) && $el.attr( 'type' ) === 'checkbox' ) {
      var x = ( $el.is( ':checked' ) ? 'true' : 'false' );
      return x;
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

  checkState = function() {
    if( $stateField.length > 0 && $stateField.val() !== '' ) {
      var stateArr = $.parseJSON( $stateField.val() ),
          x;

      for( x = 0; x < stateArr.length; x++ ) {
        if( stateArr[ x ].type === 'text' ) {
          setText( stateArr[ x ] );
        } else if( stateArr[ x ].type === 'checkbox' ) {
          setCheckbox( stateArr[ x ] );
        } else if( stateArr[ x ].type === 'radio' ) {
          setRadio( stateArr[ x ] );
        } else if( stateArr[ x ].type === 'select' ) {
          setSelect( stateArr[ x ] );
        }
      }
    }
  };

  setRadio = function( obj ) {
    if( obj.value && obj.value !== '' && obj.value !== 'unchecked' ) {
      $( '[name="' + obj.name + '"][value="' + obj.value + '"]' ).trigger( 'click' ).trigger( 'change' ).trigger( 'blur' );
    }
  };

  setCheckbox = function( obj ) {
    if ( obj.value === 'true' ) {
      $( '[name="' + obj.name + '"]' ).attr( 'checked', false ).trigger( 'click' ).trigger( 'blur' );
    }
  };

  setSelect = function( obj ) {
    $( 'select[name="' + obj.name + '"]' ).val( obj.value ).trigger( 'change' );
  };

  setText = function( obj ) {
    if( obj.name.substr( obj.name.length - 7, obj.name.length ) === '[title]' ) {
      moj.Modules.titleFields.switchToText( $( 'select[name="' + obj.name + '"]' ) );
    }

    $( '[name="' + obj.name + '"]' ).val( obj.value );
  };

  focusRadios = function() {
    $( '[type="radio"]:checked' ).trigger( 'focus' ).trigger( 'blur' );
  };

  // public

  return {
    init: init,
    registerField: registerField,
    deRegisterField: deRegisterField,
    storeState: storeState
  };

}());
