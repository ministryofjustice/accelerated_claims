/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $, Handlebars */

moj.Modules.forms = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      multiplePanels,
      showMultiples,
      setupAddressBoxes,
      manualAddressFields,
      getAddresses,
      addressDropdownFromPostcode,
      concatAddress,
      fillInAddress,
      stripeElClick,
      initStripeRows,

      //vars
      multiples,
      addressBoxes,
      stripeRows
      ;

  init = function() {
    cacheEls();
    bindEvents();

    multiplePanels();
    setupAddressBoxes(); // add 'js-address' class to sub-panels to activate
    initStripeRows();
  };

  cacheEls = function() {
    multiples = $( '.has-multiple' );
    addressBoxes = $( '.js-address' );
    stripeRows = $( '.striped-choice .row' );
  };

  bindEvents = function() {
    $( document ).on( 'change', '.multiplePanelSelector', function() {
      var $this = $( this );
      showMultiples( $this.closest( '.has-multiple' ), $this.val() );
    } ).on( 'click', '.js-manual-address', function( e ) {
      e.preventDefault();
      manualAddressFields( $( e.target ) );
    } ).on( 'click', '.js-find-address', function( e ) {
      e.preventDefault();
      addressDropdownFromPostcode( $( e.target ) );
    } ).on( 'change', '.addressDropdown', function() {
      fillInAddress( $( this ) );
    } ).on( 'click', 'input[type="radio"], input[type="checkbox"], label', function( e ) {
      if( $( e.target ).closest( '.options' ).parent( '.striped-choice' ).length > 0 ) {
        stripeElClick( e );
      }
    } );
  };



  multiplePanels = function() {
    var x,
        y,
        $panel,
        childItemClass,
        childItems,
        childItemsArray,
        source,
        template,
        context;

    if( multiples.length > 0 ) {
      source = $( '#multiple-selector' ).html();
      template = Handlebars.compile( source );

      for( x = 0; x < multiples.length; x++ ) {
        $panel = $( multiples[ x ] );
        childItemClass = $panel.data( 'multiple' );
        childItems = $panel.find( '.' + childItemClass );

        showMultiples( $panel, 1 );

        childItemsArray = [];
        for( y = 0; y < childItems.length; y++ ) {
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
        childItems = $panel.find( '.' + childItemClass );
    
    for( x = 0; x < childItems.length; x++ ) {
      if( ( x + 1 ) > show ) {
        $( childItems[ x ] ).hide();
        $( childItems[ x ] ).find( 'input[type=text], textarea' ).val( '' );

        $( childItems[ x ] ).prev( '.divider' ).hide();
      } else {
        $( childItems[ x ] ).show();
        $( childItems[ x ] ).prev( '.divider' ).show();
      }
    }
  };

  setupAddressBoxes = function() {
    var x,
        $this,
        $postcode,
        source,
        template;

    for( x = 0; x < addressBoxes.length; x++ ) {
      $this = $( addressBoxes[ x ] );
      $postcode = $this.find( 'input.smalltext' );
      $this.find( '.street, .town' ).hide();

      source = $( '#postcode-button' ).html();
      template = Handlebars.compile( source );
      $postcode.addClass( 'has-button' ).after( template( {} ) );

      source = $( '#manual-postcode-link' ).html();
      template = Handlebars.compile( source );
      $postcode.closest( '.row' ).after( template( {} ) );
    }
  };

  manualAddressFields = function( $el ) {
    var $panel = $el.closest( '.sub-panel' ),
        $pcRow = $el.closest( '.row' ).prev();

    $panel.find( '.street, .town' ).show();
    $panel.find( '.addressDropdown' ).closest( '.row' ).remove();
    $panel.find( '.street textarea, .town input, .postcode input' ).val( '' );
    $pcRow.addClass( 'rel' );
    $el.closest( '.row' ).hide();
  };

  addressDropdownFromPostcode = function( $el ) {
    var x,
        addressArray = [],
        source,
        template;

    getAddresses( function( data ) {
      source = $( '#address-dropdown' ).html();
      template = Handlebars.compile( source );

      for( x = 0; x < data.length; x++ ) {
        addressArray[ addressArray.length ] = {
          id:       data[ x ].id,
          address:  concatAddress(data[ x ].address)
        };
      }

      $el.closest( '.sub-panel' ).find( '.street textarea, .town input' ).val( '' );
      $el.closest( '.sub-panel' ).find( '.addressDropdown' ).closest( '.row' ).remove();
      $el.closest( '.row' ).after( template( {
        addresses: addressArray
      } ) );

      $el.closest( '.row' ).next().find( '.addressDropdown' ).data( 'addresses', data );
    } );
  };

  getAddresses = function( callback ) {
    $.getJSON( '/data/test-postcode-data.json', function( data ) {
      callback( data );
    } );
  };

  concatAddress = function( address ) {
    var x,
        y,
        arr = [],
        street = [];

    for( x in address ) {
      if( address[ x ] !== '' ) {
        if( x === 'street') {
          for( y in address[ x ] ) {
            if( address[ x ][ y ] !== '' ) {
              street[street.length] = address[ x ][ y ];
            }
          }
          arr[ arr.length ] = street.join( ', ' );
        } else {
          arr[ arr.length ] = address[ x ];
        }
      }
    }

    return arr.join( ', ' );
  };

  fillInAddress = function( $el ) {
    var x,
        y,
        i = $el.val(),
        $panel = $el.closest( '.sub-panel' ),
        addresses = $el.data( 'addresses' ),
        selectedAddress,
        streetAddressRows = [];

    if( i !== '' ) {
      for( x = 0; x < addresses.length; x++ ) {
        if( addresses[ x ].id === i ) {
          selectedAddress = addresses[ x ].address;
        }
      }

      $panel.find( '.street, .town' ).show();

      for( y in selectedAddress.street ) {
        if( selectedAddress.street[ y ] !== '' ) {
          streetAddressRows[ streetAddressRows.length ] = selectedAddress.street[ y ];
        }
      }

      $panel.find( '.street textarea' ).val( streetAddressRows.join( '\n' ) );
      $panel.find( '.town input' ).val( selectedAddress.town );
      $panel.find( '.postcode input' ).val( selectedAddress.postcode );
    }
  };

  stripeElClick = function( e ) {
    var $row = $( e.target ).closest( '.row' ),
        $el = $row.find( 'input[type="radio"], input[type="checkbox"]' ).eq( 0 ),
        elType = $el.attr( 'type' ),
        elName;

    if ( elType === 'radio') {
      elName = $el.attr( 'name' );
      $( 'input[name="' + elName + '"]' ).each( function() {
        var $this = $( this );
        $this.closest( '.row' ).removeClass( 'checked' );
      } );
      $row.addClass( 'checked' );
      if( $el.data( 'extra' ) ) {
        $row.closest( '.has-extra' ).addClass( 'show-extra' );
      } else {
        $row.closest( '.has-extra' ).removeClass( 'show-extra' );
      }
    } else { // checkbox
      if( $el.is( ':checked' ) ) {
        $row.addClass( 'checked' );
        if( !$row.closest( '.extra' ).length ) {
          $row.closest( '.has-extra' ).addClass( 'show-extra' );
        }
      } else {
        $row.removeClass( 'checked' );
        if( !$row.closest( '.extra' ).length ) {
          $row.closest( '.has-extra' ).removeClass( 'show-extra' );
        }
      }  
    }
  };

  initStripeRows = function() {
    $( stripeRows ).each( function(){
      var $this = $( this ),
          $el = $this.find( 'input[type="radio"], input[type="checkbox"]' ).eq( 0 );
          
      if( $el.prop( 'checked' ) ) {
        $this.addClass( 'checked' );
        $el.closest( '.has-extra' ).addClass( 'show-extra' );
      }
    } );
  };

  // public

  return {
    init: init
  };

}());
