/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.tenancyModule = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      changeDate,
      checkDates,
      hideConditionals,
      resetHidden,

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
        changeDate( $this );
      } );
    } );

    $( document ).on( 'change', '[name="claim[tenancy][assured_shorthold_tenancy_type]"]', function() {
      resetHidden();
    } );
  };

  changeDate = function( $fs ) {
    var day = $fs.find( '.day' ).val(),
        month = $fs.find( '.month' ).val(),
        year = $fs.find( '.year' ).val();


    if( day && month && year ) {
      $fs.addClass( 'selected' );
    } else {
      $fs.removeClass( 'selected' );
    }

    checkDates();
    
    if( $('.date-picker.selected').length === 0 ) {
      hideConditionals();
    }
  };

  checkDates = function() {
    var showOlder = false,
        showCurrent = false,
        visDates = $datepickers.filter( ':visible' ),
        d,
        m,
        y,
        x,
        selectedDate = 0,
        firstDate = moj.Modules.tools.stringToDate( dates.first ),
        secondDate = moj.Modules.tools.stringToDate( dates.second );

    moj.log( 'checkDates' );
    moj.log( 'visDates.length: ' + visDates.length );

    for( x = 0; x < visDates.length; x++) {
      d = $( visDates[ x ] ).find( '.day' ).val();
      m = ( $( visDates[ x ] ).find( '.month' ).val() - 1 );
      y = $( visDates[ x ] ).find( '.year' ).val();

      if( d !== '' && m !== '' && y !== '') {
        selectedDate = moj.Modules.tools.stringToDate( y + '-' + m + '-' + d );
      }

      if( selectedDate > firstDate && selectedDate <= secondDate ) {
        showOlder = true;
      } else if( selectedDate > secondDate ) {
        showCurrent = true;
      }
    }

    if( showOlder ) {
      $( '.statements.older, .js-conditionals' ).show();
    } else {
      $( '.statements.older' ).hide().find( 'input:checked' ).attr( 'checked', false );
    }

    if( showCurrent ) {
      $( '.statements.current, .js-conditionals' ).show();
    } else {
      $( '.statements.current' ).hide().find( 'input:checked' ).attr( 'checked', false );
    }

    if( !showOlder && !showCurrent ) {
      $( '.js-conditionals' ).hide();
    }
  };

  hideConditionals = function() {
    $( '.js-conditionals, .js-conditionals.statements' ).hide();
  };

  resetHidden = function() {
    $( '.conditional:hidden' ).find( 'select' ).val( '' );
    checkDates();
  };

  // public

  return {
    init: init,
    checkDates: checkDates
  };

}());
