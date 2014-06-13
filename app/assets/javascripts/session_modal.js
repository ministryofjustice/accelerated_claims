/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.sessionModal = (function() {
  "use strict";

  var //functions
      init,
      bindEvents,
      showModal,
      closeModal
      ;

  init = function() {
    bindEvents();
  };

  bindEvents = function() {
    $( document ).on( 'click', 'a#extend', function( e ) {
      e.preventDefault();

      // do session extend here
      moj.log( 'Session extended' );

      closeModal();
    } );
  };

  showModal = function() {
    var source = $( '#extend-session' ).html(),
        template = Handlebars.compile( source );

    $( 'body' ).append( template( {} ) );
    $( '#session-modal' ).modal( {
      overlayCss:   {
        background:   '#000',
        opacity:      .75
      },
      containerCss:  {
        width:        '520px',
        background:   '#fff',
        padding:      '10px'
      },
      overlayClose:   true,
      escClose:       true
    } );

  };

  closeModal = function() {
    $.modal.close();
  };

  // public

  return {
    init: init,
    showModal: showModal,
    closeModal: closeModal
  };

}());
