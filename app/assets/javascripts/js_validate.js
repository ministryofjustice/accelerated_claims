/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.jsValidate = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
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
    $numClaimants = $( '[name="claim[num_claimants]"]', $form );
    $secondClaimantAddressSameAsFirst = $( '[name="claimant2address"]', $form );

    $firstClaimantAddress = $( '[name="claim[claimant_1][street]"]', $form );
    $secondClaimantAddress = $( '[name="claim[claimant_2][street]"]', $form );
    $firstClaimantPostcode = $( '[name="claim[claimant_1][postcode]"]', $form );
    $secondClaimantPostcode = $( '[name="claim[claimant_2][postcode]"]', $form );
  };

  bindEvents = function() {
    $form.on( 'submit', function( e ) {
      e.preventDefault();
      checkData();
    } );
  };

  checkData = function() {
    // if( moj.Modules.tools.getTextFieldValue( $numClaimants ) === '2' ) {
    //   if( moj.Modules.tools.getRadioVal( $secondClaimantAddressSameAsFirst ) === 'yes' ) {
    //     $( '#claimant_2 .address' ).show();
    //     $secondClaimantAddress.val( $firstClaimantAddress.val() );
    //     $secondClaimantPostcode.val( $firstClaimantPostcode.val() );
    //   }
    // }

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
