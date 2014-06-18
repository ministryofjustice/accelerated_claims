/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.sessionTimeout = (function() {
  "use strict";

  var //functions
      init,
      startTimer,
      showPopup,
      refreshSession,
      endSession,

      //vars
      timer = null,
      sessionMinutes = 60,
      warnMinutesBeforeEnd = sessionMinutes / 4,
      minute = 60 * 1000,
      quick = false
      ;

  init = function() {
    quick = moj.Modules.tools.getQueryVar( 'quick' );
    if( quick === 'true' ) {
      sessionMinutes = 2;
      warnMinutesBeforeEnd = 1.5;
    }

    if( $( 'form#claimForm' ).length > 0 ) {
      startTimer();
    }
  };

  startTimer = function() {
    if( timer ) {
      window.clearTimeout( timer );
      timer = null;
    }

    timer = window.setTimeout( function() {
      showPopup();
    }, ( sessionMinutes - warnMinutesBeforeEnd ) * minute );
  };

  showPopup = function() {
    timer = window.setTimeout( function() {
      endSession();
    }, warnMinutesBeforeEnd * minute );

    moj.Modules.sessionModal.showModal( function() {
      refreshSession();
    }, sessionMinutes, warnMinutesBeforeEnd );
  };

  refreshSession = function() {
    $.get( '/heartbeat', function() {
      moj.Modules.sessionModal.closeModal();
      startTimer();
    } );
  };

  endSession = function() {
    $.ajax( {
      type:     'get',
      url:      '/expire_session?redirect=false',
      success:  function( data, textStatus, jqXHR ) {
        moj.log( textStatus );
        document.location.href = '/expired';
      },
      error:    function( jqXHR, textStatus, errorThrown ) {
        moj.log( 'error' );
        moj.log( jqXHR );
        moj.log( textStatus );
        moj.log( errorThrown );
      }
    } );
  };

  // public

  return {
    init: init
  };

}());
