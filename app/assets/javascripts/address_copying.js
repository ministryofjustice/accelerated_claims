/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.addressCopying = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      checkData,
      submitForm,

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
    $numClaimants = $( 'input[name="multiplePanelRadio_claimants"]' );
    $secondClaimantAddressSameAsFirst = $( 'input[name="claimant2address"]' );

    $firstClaimantAddress = $( '[name="claim[claimant_one][street]"]' );
    $secondClaimantAddress = $( '[name="claim[claimant_two][street]"]' );
    $firstClaimantPostcode = $( '[name="claim[claimant_one][postcode]"]' );
    $secondClaimantPostcode = $( '[name="claim[claimant_two][postcode]"]' );
  };

  bindEvents = function() {
    $form.on( 'submit', function( e ) {
      var data;

      e.preventDefault();

      checkData();
    } );
  };

  checkData = function() {
    if( moj.Modules.tools.getRadioVal( $numClaimants ).toString() === '2' ) {
      if( moj.Modules.tools.getRadioVal( $secondClaimantAddressSameAsFirst ) === 'yes' ) {
        $secondClaimantAddress.val( $firstClaimantAddress.val() );
        $secondClaimantPostcode.val( $firstClaimantPostcode.val() );
      }
    }

    submitForm();
  };

  submitForm = function() {
    $form.unbind( 'submit' );

    window.setTimeout( function(){
      $submitButton.trigger( 'click' );
    }, 100 );
  };

  // public

  return {
    init: init
  };

}());
