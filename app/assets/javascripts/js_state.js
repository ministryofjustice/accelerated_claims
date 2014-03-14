/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.jsState = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      testPopulate,
      registerField,
      storeState

      //elements
      $stateField,

      //data
      watchEls = [],
      testData = [
        {
          id: 'claim_claimant_two_address',
          type: 'radio',
          value:  'yes'
        }
      ]
      ;

  init = function() {
    cacheEls();
    bindEvents();

    testPopulate();
  };

  cacheEls = function() {
    $stateField = $( '#js-state' );
  };

  bindEvents = function() {

  };

  testPopulate = function() {
    var v = JSON.stringify( testData );
    moj.log( v );
    $stateField.val( v );
  };

  registerField = function( $el ) {
    watchEls[ watchEls.length ] = $el;
    $el.on( 'change', function() {
      storeState();
    } );
  };

  storeState = function() {
    // YOU ARE HERE
  };

  // public

  return {
    init: init,
    registerField: registerField
  };

}());
