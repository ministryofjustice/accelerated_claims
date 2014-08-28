/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.sessionModal = (function() {
  "use strict";

  var //functions
      init,
      showModal,
      closeModal,
      timeString,
      startCountdown,
      cancelCountdown,
      writeTime,

      //vars
      countdownTimer
      ;

  init = function() {
  };

  showModal = function( refreshSession, sessionMinutes, warnBeforeEndMinutes ) {
    var source = $( '#extend-session' ).html(),
        template = Handlebars.compile( source ),
        sessionString,
        remainingString;

    sessionString = timeString( sessionMinutes );
    remainingString = timeString( warnBeforeEndMinutes );

    $( 'body' ).append( template( {
      sessionString: sessionString,
      remainingString: remainingString
    } ) );


    $( '#session-modal' ).modal( {
      overlayCss:   {
        background:   '#000'
      },
      opacity:      65,
      containerCss:  {
        width:        '530px',
        background:   '#fff',
        padding:      '10px'
      },
      overlayClose:   false,
      escClose:       false,
      onShow: function() {
        window.setTimeout( function() {
          $('#session-modal').find('a#extend').focus();
        }, 100 );
      }
    } );

    $( '#session-modal' ).find( 'a#extend' ).on( 'click' , ( function( _this, callback ) {
      return function( e ) {
        e.preventDefault();
        callback();
        _this.closeModal();
      };
    } ( this, refreshSession ) ) );

    startCountdown( warnBeforeEndMinutes );
  };

  closeModal = function() {
    $.modal.close();
    $( '#session-modal' ).remove();
    cancelCountdown();
  };

  timeString = function( minutes ) {
    var m;
    if( minutes >= 1 ) {
      m = Math.ceil( minutes );
      return m + ' minute' + ( m === 1 ? '' : 's' ) + '.';
    }
    return parseInt( minutes * 60, 10 ) + ' second' + ( (Math.floor( minutes * 60 ) === 1) ? '' : 's' ) + '.';
  };

  startCountdown = function( remaining ) {
    countdownTimer = new window.EndTimer(function() {}, remaining, new Date(), function(millisecondsLeft) {
        var secondsRemaining = millisecondsLeft / 1000;
        if( secondsRemaining > 0 ) {
          writeTime( secondsRemaining / 60 );
        } else {
          cancelCountdown();
        }
    });
  };

  cancelCountdown = function() {
    countdownTimer.stopTimer();
  };

  writeTime = function( t ) {
    $( '#timeRemaining' ).text( timeString( t ) );
  };

  return {
    init: init,
    showModal: showModal,
    closeModal: closeModal
  };

}());
