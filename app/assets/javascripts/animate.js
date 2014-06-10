/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.animate = (function() {
  "use strict";

  var //functions
      init,
      showhide,
      scrollToTop,
      mouseWithin,

      //vars
      animateFlag = false,
      ms = 450,
      mpos = {
        x: 0,
        y: 0
      }
      ;

  init = function() {
    if( window.location.search && moj.Modules.tools.getQueryVar( 'anim' ).toString() === 'true' ) {
      animateFlag = true;
    }

    if( animateFlag ) {
      $( window ).on( 'mousemove', function( e ) {
        mpos.x = e.pageX;
        mpos.y = e.pageY;
      } );
    }
  };

  showhide = function( $el, $srcEl, sh, callback ) {
    var showIt,
        doCallback = function() {
          if( callback ) {
            callback();
          }
        };

    if( animateFlag ) {
      if( sh === 'show' ) {
        showIt = function() {
          $el.slideDown( ms, function() {
            doCallback();
          } );
        };

        if ( $srcEl && mouseWithin( $srcEl.closest( 'fieldset' ) ) ) {
          scrollToTop( $srcEl.closest( 'fieldset' ), function() {
            showIt();
          } );
        } else {
          showIt();
        }
      } else if ( sh === 'hide' ) {
        $el.slideUp( ms, function() {
          doCallback();
        } );
      }
    } else {
      if( sh === 'show' ) {
        $el.show();
        doCallback();
      } else if( sh === 'hide' ) {
        $el.hide();
        doCallback();
      }
    }
  };

  scrollToTop = function( $el, callback ) {
    var sy = window.scrollY,
        ey = $el.offset().top,
        doCallback = function() {
          if( callback ) {
            callback();
          }
        };

    if( Math.abs( sy - ey ) < 100 ) {
      window.scrollTo( window.scrollX, ey );
      doCallback();
    } else {
      $( 'body, html' ).animate( {
        scrollTop: $el.offset().top
      }, ms, function() {
        doCallback();
      } );
    }
  };

  mouseWithin = function ( $el ) {
    var x = $el.offset().left,
        y = $el.offset().top,
        w = $el.outerWidth( true ),
        h = $el.outerHeight( true ),
        realClick = false;

    if( mpos.x > x && mpos.x < ( x + w ) && mpos.y > y && mpos.y < ( y + h ) ) {
      realClick = true;
    }

    return realClick;
  };

  // public

  return {
    init: init,
    showhide: showhide
  };

}());
