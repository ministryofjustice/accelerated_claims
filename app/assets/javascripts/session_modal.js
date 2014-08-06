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
      countdown
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

  timeString = function( t ) {
    var m;
    if( t >= 1 ) {
      m = Math.ceil( t );
      return m + ' minute' + ( m === 1 ? '' : 's' ) + '.';
    }
    return parseInt( t * 60, 10 ) + ' second' + ( ( t * 60 ) === 1 ? '' : 's' ) + '.';
  };

  startCountdown = function( remaining ) {
    var interval = 1, // seconds
        secondsRemaining = remaining * 60;

    countdown = window.setInterval( function() {
      if( secondsRemaining > 0 ) {
        secondsRemaining -= interval;
        writeTime( secondsRemaining / 60 );
      } else {
        cancelCountdown();
      }
    }, interval * 1000 );
  };

  cancelCountdown = function() {
    window.clearInterval( countdown );
    countdown = null;
  };

  writeTime = function( t ) {
    $( '#timeRemaining' ).text( timeString( t ) );
  };

  // public

  return {
    init: init,
    showModal: showModal,
    closeModal: closeModal
  };

}());
