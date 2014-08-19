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
      expand_claimants,

      //elements
      $multiples,
      $claimantSolicitor
      ;

  init = function() {
    $.hidden = new Object();
    cacheEls();
    bindEvents();

    setupMultiples();
  };

  cacheEls = function() {
    $multiples = $( '.has-multiple' );
    $claimantSolicitor = $('.claimant-solicitor');
  };

  bindEvents = function() {
    
    $('[name=claim\\[claimant_type\\]]').on('change', expand_claimants());

    //number of claimants
    $( document ).on( 'change', '.has-multiple .multiple [type="radio"]', function() {
      console.log("EXAPANDED CLICKING");
      var $this = $( this );
      showMultiples($this.closest( '.has-multiple' ), $this, $this.val());
    });
  };



expand_claimants = function() {
  //type of claimant
  var claimantType = $(this).val();
  var $checked = $('[name=claim\\[num_claimants\\]]:checked');

  if(claimantType==='individual'){
    showMultiples($(this).closest('.has-multiple'), $checked, $checked.val());
  }
  else{
    showMultiples($(this).closest('.has-multiple'), $checked, 1);
  }
};









  setupMultiples = function() {
    var x,
        $panel;

    if( $multiples.length > 0 ) {
      for( x = 0; x < $multiples.length; x++ ) {
        $panel = $multiples.eq( x );
        showMultiples( $panel, null, 0 );

        moj.Modules.jsState.registerField( $( '[name="claim[num_' + $panel.attr( 'id' ) + ']"]' ) );
      }
    }
  };

  showMultiples = function( $panel, $srcEl, shownum ) {
    var x,
        section,
        show = shownum || 0,
        childItemClass = $panel.data( 'multiple' ),
        $childItems = $panel.find( '.' + childItemClass );

    if($srcEl && $srcEl.attr('name')==='claim[num_claimants]'){
      $claimantSolicitor.toggle(shownum>0);
    }

    for( x = 0; x < $childItems.length; x++ ) {
      section = $childItems.eq( x );
      if( ( x + 1 ) > show ) {
        moj.Modules.animate.showhide( section.prev( '.divider' ), $srcEl, 'hide' );
        moj.Modules.animate.showhide( section, $srcEl, 'hide' );
        $.hidden[ section.attr('id') ] = true;
      } else {
        moj.Modules.animate.showhide( section.prev( '.divider' ), $srcEl, 'show' );
        moj.Modules.animate.showhide( section, $srcEl, 'show' );
        $.hidden[ section.attr('id') ] = false;
      }
    }

    if( show > 1 ) {
      moj.Modules.animate.showhide( $childItems.find( '.person' ), $srcEl, 'show', function() {
        $childItems.find( '.person' ).next( '.row' ).removeClass( 'nomargin' );
      } );
    } else {
      moj.Modules.animate.showhide( $childItems.find( '.person' ), $srcEl, 'hide', function() {
        $childItems.find( '.person' ).next( '.row' ).addClass( 'nomargin' );
      } );
    }
  };

  // public

  return {
    init: init
  };

}());
