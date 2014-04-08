/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.addressCopying = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      copyAddresses,
      copyAddress,
      createFakeSubmitButton,
      submitForm,

      //elements
      $addressPanels,
      $form,
      $submitButton,
      $sourceAddressPanel,
      $claimantOneAddressPanel,
      $propertyAddressPanel
      ;

  init = function() {
    cacheEls();
    bindEvents();

    createFakeSubmitButton();
  };

  cacheEls = function() {
    $addressPanels = $( '#claimant_two, .sub-panel.defendant' );
    $form = $( 'form#claimForm' ).eq( 0 );
    $submitButton = $form.find( '#submit' );
    $claimantOneAddressPanel = $( '.sub-panel#claimant_one' );
    $propertyAddressPanel = $( '.sub-panel#property' );
  };

  bindEvents = function() {
    $( document ).on( 'click', '#fakeSubmit', function( e ) {
      e.preventDefault();

      copyAddresses( function() {
        submitForm();
      } );
    } );
  };

  createFakeSubmitButton = function() {
    $submitButton.after( $submitButton.clone().attr( 'id', 'fakeSubmit' ) ).hide();
  };

  copyAddresses = function( callback ) {
    $addressPanels.each( function() {
      var $this = $( this ),
          $sourceAddressPanel;

      if( $this.find( 'input.yesno[value="yes"]' ).is( ':checked' ) ) {
        if( $this.hasClass( 'claimant' ) ) {
          $sourceAddressPanel = $claimantOneAddressPanel;
        } else if( $this.hasClass( 'defendant' ) ) {
          $sourceAddressPanel = $propertyAddressPanel;
        }

        copyAddress( $sourceAddressPanel, $this );
      }
    } );

    callback();
  };

  copyAddress = function( $src, $target ) {
    $target.find( '.street textarea' ).val( $src.find( '.street textarea' ).val() );
    $target.find( '.postcode input[type="text"]' ).val( $src.find( '.postcode input[type="text"]' ).val() );
  };

  submitForm = function() {
    $submitButton.click();
  };

  // public

  return {
    init: init
  };

}());
