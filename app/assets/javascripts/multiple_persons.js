/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.multiplePersons = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      setupMultiples,
      showMultiples,

      //elements
      $multiples
      ;

  init = function() {
    $.hidden = new Object();
    cacheEls();
    bindEvents();

    setupMultiples();
  };

  cacheEls = function() {
    $multiples = $( '.has-multiple' );
  };

  bindEvents = function() {
    $( document ).on( 'change', '.multiplePanelRadio', function() {
      var $this = $( this );
      showMultiples( $this.closest( '.has-multiple' ), $this.val() );
    } );
  };

  setupMultiples = function() {
    var x,
        y,
        $panel,
        childItemClass,
        $childItems,
        childItemsArray,
        source,
        template,
        context;

    if( $multiples.length > 0 ) {
      source = $( '#multiple-radio' ).html();
      template = Handlebars.compile( source );

      for( x = 0; x < $multiples.length; x++ ) {
        childItemsArray = [];
        $panel = $multiples.eq( x );
        childItemClass = $panel.data( 'multiple' );
        $childItems = $panel.find( '.' + childItemClass );

        for( y = 0; y < $childItems.length; y++ ) {
          childItemsArray[ childItemsArray.length ] = {
            val:    y + 1,
            text:   ( y + 1 ) + ' ' + ( y === 0 ? $panel.data( 'single' ) : $panel.data( 'plural' ) ),
            group:  $panel.attr( 'id' )
          };
        }

        context = {
          id:       $panel.attr( 'id' ),
          caption:  $panel.data( 'caption' ),
          items:    childItemsArray
        };

        $panel.prepend( template( context ) );

        showMultiples( $panel, 0 );

        moj.Modules.jsState.registerField( $( '[name="multiplePanelRadio_' + $panel.attr( 'id' ) + '"]' ) );
      }
    }
  };

  showMultiples = function( $panel, shownum ) {
    var x,
        section,
        show = shownum || 0,
        childItemClass = $panel.data( 'multiple' ),
        $childItems = $panel.find( '.' + childItemClass );

    for( x = 0; x < $childItems.length; x++ ) {
      section = $childItems.eq( x );
      if( ( x + 1 ) > show ) {
        section.prev( '.divider' ).hide();
        section.hide();
        $.hidden[ section.attr('id') ] = true;
      } else {
        section.prev( '.divider' ).show();
        section.show();
        $.hidden[ section.attr('id') ] = false;
      }
    }

    if( show > 1 ) {
      $childItems.find( '.person' ).show().next( '.row' ).removeClass( 'nomargin' );
    } else {
      $childItems.find( '.person' ).hide().next( '.row' ).addClass( 'nomargin' );
    }
  };

  // public

  return {
    init: init
  };

}());
