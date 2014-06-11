/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

// Module to replace certain pieces of copy with alternatives or remove them entirely if JS is present

moj.Modules.dateDigits = (function() {
  "use strict";

  var //functions
      init,
      checkTwoDigits
      ;

  init = function() {
    $( '.moj-date-year' ).on( 'blur', function( e ) {
      checkTwoDigits( $( e.target ) );
    } );
  };

  checkTwoDigits = function ( $el ) {
    var v = $el.val(),
        c;

    if( v.toString().length === 2 && !isNaN( parseInt( v, 10 ) ) ) {
      c = ( parseInt( v, 10 ) > 68 ? '19' : '20');
      $el.val( c + v );
      
      if( $el.closest( 'fieldset' ).hasClass( 'conditional' ) ) {
        moj.Modules.tenancyModule.checkDates();
      }
    }
  };

  // public

  return {
    init: init
  };

}());
