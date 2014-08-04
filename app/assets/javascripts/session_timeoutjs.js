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
    if( timer ) {
      window.clearTimeout( timer );
      timer = null;
    }

    timer = window.setTimeout( function() {
      showPopup();
    }, ( sessionMinutes - warnMinutesBeforeEnd ) * minute );
  };

  showPopup = function() {
    moj.Modules.sessionModal.showModal( function() {
      refreshSession();
    }, sessionMinutes, warnMinutesBeforeEnd );
    timer = window.setTimeout( function() {
      endSession();
    }, warnMinutesBeforeEnd * minute );
  };

  refreshSession = function() {
    $.get( basePath + '/heartbeat', function() {
      moj.Modules.sessionModal.closeModal();
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
        moj.log( textStatus );
        document.location.href = basePath + '/expired';
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