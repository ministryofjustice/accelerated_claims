/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.yesno = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      questionSetup,
      yesnoClick,

      //elements
      questions
      ;

  init = function() {
    cacheEls();
    bindEvents();

    $( questions ).each( function() {
      questionSetup( $( this ) );
    } );
  };

  cacheEls = function() {
    questions = $( '.js-yesno' );
  };

  bindEvents = function() {
    $( document ).on( 'click', 'input.yesno', function() {
      yesnoClick( $( this ) );
    } );
  };

  questionSetup = function ( $el ) {
    var source,
        template,
        context;

    $el.find( '.row' ).eq( 0 ).remove();
    $el.hide();

    source = $( '#hb-yesno' ).html();
    template = Handlebars.compile( source );
    context = { question: $el.data( 'yesnoquestion' ), id: $el.data( 'yesnoid' ), req: $el.data( 'yesnoreq' ), full: 'true' };

    $el.before( template( context ) );
  };

  yesnoClick = function( $el ) {
    var reverse = $el.closest( '.options' ).data( 'reverse' );
    if( ( $el.val() === 'yes' && !reverse ) || ( $el.val() === 'no' && reverse ) ) {
      $el.closest( 'fieldset' ).next().show();
    } else {
      $el.closest( 'fieldset' ).next().hide().find( 'input[type=text], textarea' ).val( '' );
    }
  };

  // public

  return {
    init: init
  };

}());
