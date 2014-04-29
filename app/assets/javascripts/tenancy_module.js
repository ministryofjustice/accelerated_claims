/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.tenancyModule = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      checkDate,

      //elements
      $optionsDiv,
      $datepickers,

      //data
      dates = {
        first:    '1989-01-15',
        second:   '1997-02-28'
      }
      ;

  init = function() {
    cacheEls();
    bindEvents();

    $optionsDiv.addClass( 'inset' ).find( '.inset' ).removeClass( 'inset' ).removeClass( 'sub-panel' );


  };

  cacheEls = function() {
    $optionsDiv = $( '.assuredTenancyOptions' ).eq( 0 );
    $datepickers = $( '.date-picker.conditional' );
  };

  bindEvents = function() {
    $datepickers.each( function() {
      var $this = $( this );
      $this.find( 'select' ).on( 'change', function() {
        checkDate( $this );
      } );
    } );
  };

  checkDate = function( $fs ) {
    var day = $fs.find( '.day' ).val(),
        month = $fs.find( '.month' ).val(),
        year = $fs.find( '.year' ).val();


    if( day && month && year ) {
      moj.log(day + '-' + month + '-' + year);
    }
  };

  // public

  return {
    init: init
  };

}());
