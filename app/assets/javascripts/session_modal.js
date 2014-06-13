/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.sessionModal = (function() {
  "use strict";

  var //functions
      init,
      showModal,
      closeModal
      ;

  init = function() {

  };

  showModal = function( refreshSession ) {
    var source = $( '#extend-session' ).html(),
        template = Handlebars.compile( source );

    $( 'body' ).append( template( {} ) );

    $("#session-modal").find("a#extend").on("click", (function(_this, callback) {
      return function(e) {
        e.preventDefault();
        callback();
        _this.closeModal();
      };
    })(this, refreshSession));


    $( '#session-modal' ).modal( {
      overlayCss:   {
        background:   '#000',
        opacity:      0.75
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
