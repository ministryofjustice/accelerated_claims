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
    cacheEls();
    bindEvents();

    setupMultiples();
  };

  cacheEls = function() {
    $multiples = $( '.has-multiple' );
  };

  bindEvents = function() {
    $( document ).on( 'change', '.multiplePanelSelector', function() {
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
      source = $( '#multiple-selector' ).html();
      template = Handlebars.compile( source );

      for( x = 0; x < $multiples.length; x++ ) {
        childItemsArray = [];
        $panel = $multiples.eq( x );
        childItemClass = $panel.data( 'multiple' );
        $childItems = $panel.find( '.' + childItemClass );
        $childItems.addClass( 'rel' );

        showMultiples( $panel, 1 );

        for( y = 0; y < $childItems.length; y++ ) {
          childItemsArray[ childItemsArray.length ] = {
            val:    y + 1,
            text:   ( y === 0 ? $panel.data( 'single' ) : $panel.data( 'plural' ) )
          };
        }

        context = {
          id:       $panel.attr( 'id' ),
          caption:  $panel.data( 'caption' ),
          items:    childItemsArray
        };

        $panel.prepend( template( context ) );
      }
    }
  };

  showMultiples = function( $panel, shownum ) {
    var x,
        show = shownum || 1,
        childItemClass = $panel.data( 'multiple' ),
        $childItems = $panel.find( '.' + childItemClass );
    
    for( x = 0; x < $childItems.length; x++ ) {
      if( ( x + 1 ) > show ) {
        $childItems.eq( x ).hide();
        $childItems.eq( x ).find( 'input[type=text], textarea' ).val( '' );

        $childItems.eq( x ).prev( '.divider' ).hide();
      } else {
        $childItems.eq( x ).show();
        $childItems.eq( x ).prev( '.divider' ).show();
      }
    }

    if( show > 1 ) {
      $childItems.find( 'h4' ).show();
    } else {
      $childItems.find( 'h4' ).hide(); 
    }
  };

  // public

  return {
    init: init
  };

}());
