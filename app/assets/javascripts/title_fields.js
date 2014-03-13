/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.titleFields = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      switchToDropdowns,
      switchToText,

      //elements
      $origFields,

      //data
      titles = [
        'Mr',
        'Mrs',
        'Miss',
        'Ms',
        'Dr'
      ]
      ;

  init = function() {
    cacheEls();
    bindEvents();

    switchToDropdowns();
  };

  cacheEls = function() {
    $origFields = $( '.row.title input[type="text"]' );
  };

  bindEvents = function() {
    $( document ).on( 'change', '.title-dropdown', function() {
      var $this = $( this );
      if( $this.val() === 'other' ) {
        switchToText( $this );
      }
    } );
  };

  switchToDropdowns = function() {
    $origFields.each( function() {
      var $this = $( this ),
          id = $this.attr( 'id' ),
          name = $this.attr( 'name' ),
          context,
          source,
          template;

      source = $( '#title-dropdown' ).html();
      template = Handlebars.compile( source );
      context = { id: id, name: name, titles: titles };

      $this.after( template( context ) );
      $this.remove();
    } );
  };

  switchToText = function( $el ) {
    var id = $el.attr( 'id' ),
        name = $el.attr( 'name' ),
        context,
        source,
        template;

    source = $( '#title-input' ).html();
    template = Handlebars.compile( source );
    context = { id: id, name: name };

    $el.after( template( context ) );
    $el.remove();
  };

  // public

  return {
    init: init
  };

}());
