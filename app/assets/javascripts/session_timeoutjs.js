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
      endSessionTimer = null,
      endSessionTime = null,
      sessionMinutes = 55,
      warnMinutesBeforeEnd = 15,
      elapsedMinutes,
      minute = 60 * 1000,
      quick = false,
      baseProtocol = window.location.protocol,
      baseDomain = window.location.host,
      baseUrl = moj.Modules.relativeUrlRoot,
      basePath = baseProtocol + '//' + baseDomain + ( baseUrl === '' ? '' : '/' + baseUrl )
      ;

  init = function() {
    quick = moj.Modules.tools.getQueryVar( 'quick' );

    if( $( 'div#activateModalSessionTimer' ).length > 0 ) {
      if( quick === 'true' ) {
        sessionMinutes = 2;
        warnMinutesBeforeEnd = 1.5;
      } else if( quick === 'very' ) {
        sessionMinutes = 0.15;
        warnMinutesBeforeEnd = 0.1;
      } else if( quick && !isNaN( quick ) ) {
        sessionMinutes = quick;
        warnMinutesBeforeEnd = sessionMinutes / 2;
      }

      startTimer();
    }
  };

  startTimer = function() {
    var sessionStartTime = new Date();
    endSessionTime = new Date( sessionStartTime.getTime() + (sessionMinutes * 60 * 1000) )

    var popupDelay = ( sessionMinutes - warnMinutesBeforeEnd );
    new window.EndTimer(function() { showPopup(); }, popupDelay, sessionStartTime );

    var endSessionDelay = sessionMinutes;
    endSessionTimer = new window.EndTimer(function() { endSession(); }, endSessionDelay, sessionStartTime );
  };

  showPopup = function() {
    var minutesToEnd = (endSessionTime.getTime() - new Date().getTime()) / (60 * 1000);

    if( minutesToEnd > 0) {
      moj.Modules.sessionModal.showModal( function() { refreshSession(); },
        sessionMinutes, minutesToEnd );
    } else {
      endSession();
    }
  };

  refreshSession = function() {
    $.get( basePath + '/heartbeat', function() {
      moj.Modules.sessionModal.closeModal();
      endSessionTimer.stopTimer();
      startTimer();
    } );
  };

  endSession = function() {
    $.ajax( {
      type:     'post',
      url:      basePath + '/expire_session',
      data:     {
        redirect:   false
      },
      success:  function( data, textStatus, jqXHR ) {
        document.location.href = basePath + '/expired';
      },
      error:    function( jqXHR, textStatus, errorThrown ) {
        moj.log( 'error' );
        moj.log( jqXHR );
        moj.log( textStatus );
        moj.log( errorThrown );
        document.location.href = basePath + '/expired';
      }
    } );
  };

  // public

  return {
    init: init
  };

}());
