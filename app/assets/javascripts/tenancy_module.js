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

    $( '#read-statements' ).text( 'Read the statements below and select all that apply:' ).addClass( 'strong' ).prependTo( $( '.js-conditionals' ) );
  };

  cacheEls = function() {
    $optionsDiv = $( '.assuredTenancyOptions' ).eq( 0 );
    $datepickers = $( '.date-picker.conditional' );
  };

  bindEvents = function() {
    $datepickers.each( function() {
      var $this = $( this );
      $this.find( '[type="text"]' ).on( 'keyup', function() {
        changeDate( $this );
      } );
    } );

    $( document ).on( 'change', '[name="claim[tenancy][assured_shorthold_tenancy_type]"]', function() {
      window.setTimeout( function(){
        resetHidden();
      }, 1 );
    } );
  };

  changeDate = function( $fs ) {
    var day = $fs.find( '.moj-date-day' ).val(),
        month = $fs.find( '.moj-date-month' ).val(),
        year = $fs.find( '.moj-date-year' ).val();


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
        valMonth,
        y,
        x,
        selectedDate = 0,
        firstDate = moj.Modules.tools.stringToDate( dates.first ),
        secondDate = moj.Modules.tools.stringToDate( dates.second );

    for( x = 0; x < visDates.length; x++) {
      d = $( visDates[ x ] ).find( '.moj-date-day' ).val();
      m = ( $( visDates[ x ] ).find( '.moj-date-month' ).val() );
      y = $( visDates[ x ] ).find( '.moj-date-year' ).val();

      if( d !== '' && m !== '' && y !== '' && moj.Modules.tools.isDate( d, m, y ) ) {
        valMonth = moj.Modules.tools.validMonth( m );
        if( valMonth ) {
          selectedDate = moj.Modules.tools.stringToDate( y + '-' + valMonth + '-' + d );
        }
      }

      if( selectedDate >= firstDate && selectedDate < secondDate ) {
        showOlder = true;
      } else if( selectedDate >= secondDate ) {
        showCurrent = true;
      }
    }

    if( showOlder ) {
      $( '.statements.older, .js-conditionals' ).show();
    } else {
      $( '.statements.older' ).hide().find( ':checked' ).attr( 'checked', false );
    }

    if( showCurrent ) {
      $( '.statements.current, .js-conditionals' ).show();
    } else {
      $( '.statements.current' ).hide().find( ':checked' ).attr( 'checked', false );
    }

    if( !showOlder && !showCurrent ) {
      $( '.js-conditionals' ).hide();
    }
  };

  hideConditionals = function() {
    $( '.js-conditionals, .js-conditionals.statements' ).hide();
  };

  resetHidden = function() {
    $( '.conditional:hidden' ).find( '[type="text"]' ).val( '' );
    checkDates();
  };

  // public

  return {
    init: init,
    checkDates: checkDates
  };

}());
