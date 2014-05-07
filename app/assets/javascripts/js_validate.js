/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.jsValidate = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      jsValidate,
      checkData,
      submitForm,
      clearHidden,

      //elements
      $form,
      $submitButton,
      $numClaimants,
      $secondClaimantAddressSameAsFirst,
      $firstClaimantAddress,
      $firstClaimantPostcode,
      $secondClaimantAddress,
      $secondClaimantPostcode
      ;

  init = function() {
    cacheEls();
    bindEvents();
  };

  cacheEls = function() {
    $form = $( 'form#claimForm' ).eq( 0 );
    $submitButton = $( '#submit', $form );
    $numClaimants = $( '[name="multiplePanelRadio_claimants"]', $form );
    $secondClaimantAddressSameAsFirst = $( '[name="claimant2address"]', $form );

    $firstClaimantAddress = $( '[name="claim[claimant_one][street]"]', $form );
    $secondClaimantAddress = $( '[name="claim[claimant_two][street]"]', $form );
    $firstClaimantPostcode = $( '[name="claim[claimant_one][postcode]"]', $form );
    $secondClaimantPostcode = $( '[name="claim[claimant_two][postcode]"]', $form );
  };

  bindEvents = function() {
    $form.on( 'submit', function( e ) {
      e.preventDefault();
      jsValidate();
    } );
  };

  jsValidate = function() {
    var errors = [],
        checkEls = $( '.jsVal:visible' ),
        x;

    $( '.error-summary' ).remove();
    $( 'h3 > .error' ).remove();
    $( 'fieldset.error' ).removeClass( 'error' );

    for( x = 0; x < checkEls.length; x++ ) {
      if( $( checkEls[ x ] ).hasClass( 'radio' ) ) {
        if( $( checkEls[ x ] ).find( ':checked' ).length === 0 ) {
          errors.push( {
            text: 'Question "' + $( checkEls[ x ] ).find( '.caption' ).eq( 0 ).text() + '" not answered',
            num:  x
          } );
          $( checkEls[ x ] ).addClass( 'error' ).find( '.caption' ).eq( 0 ).attr( 'id', 'jsError' + x ).append( '<span class="error">Must be answered</span>' );
        }
      }
    }

    if( errors.length === 0) {
      checkData();
    } else {
      moj.Modules.tools.jsError( errors );
    }
  };

  checkData = function() {
    if( moj.Modules.tools.getRadioVal( $numClaimants ).toString() === '2' ) {
      if( moj.Modules.tools.getRadioVal( $secondClaimantAddressSameAsFirst ) === 'yes' ) {
        $( '#claimant_two .address' ).show();
        $secondClaimantAddress.val( $firstClaimantAddress.val() );
        $secondClaimantPostcode.val( $firstClaimantPostcode.val() );
      }
    }

    submitForm();
  };

  submitForm = function() {
    clearHidden();

    $form.unbind( 'submit' );

    // this looks horrible but it's necessary
    window.setTimeout( function(){
      $submitButton.trigger( 'click' );
    }, 100 );
  };

  clearHidden = function() {
    $( '[type=text]:hidden, textarea:hidden, select:hidden', $form ).val('');
    $( ':checked:hidden', $form ).attr( 'checked', false );
  };

  // public

  return {
    init: init
  };

}());
