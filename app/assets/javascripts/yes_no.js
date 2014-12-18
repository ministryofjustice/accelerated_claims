/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.yesNo = (function() {
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
        context,
        questionHtml,
        $row;

    $row = $el.find( '.row' ).eq( 0 );
    questionHtml = $row.html();
    $row.remove();
    $el.hide();

    source = $( '#hb-yesno' ).html();
    template = Handlebars.compile( source );
    context = { id: $el.data( 'yesnoid' ), req: $el.data( 'yesnoreq' ), full: 'true' };

    $el.before( template( context ) );
    $el.prev( 'fieldset' ).find( 'legend' ).prepend( questionHtml );

    moj.Modules.jsState.registerField( $( '[name=' + $el.data( 'yesnoid' ) + ']' ) );
  };

  yesnoClick = function( $el ) {
    var reverse = $el.closest( '.options' ).data( 'reverse' );
    if(typeof reverse === 'undefined') {
      reverse = $el.closest( '.inline' ).data( 'reverse' );
    }
    var nextDiv = $el.closest( 'fieldset' ).next();
    nextDiv = nextDiv[0] ? nextDiv : $el.closest( 'fieldset' ).parent().next();

    if( ( $el.val() === 'Yes' && !reverse ) || ( $el.val() === 'No' && reverse ) ) {
      moj.Modules.animate.showhide( nextDiv, $el, 'show' );
    } else {
      moj.Modules.animate.showhide( nextDiv, $el, 'hide' );
    }
  };

  // public

  return {
    init: init
  };

}());
