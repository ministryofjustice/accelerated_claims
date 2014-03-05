/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.eventTracking = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      bindEvents,
      eventCategory,
      dispatchTrackingEvent,

      // vars
      $tracked_elements
      ;

  init = function() {
    cacheEls();
    bindEvents();
  };

  cacheEls = function() {
    $tracked_elements = $( '[data-event-label]' );
  };

  bindEvents = function() {
    $tracked_elements.on( 'click', function() {
      var category = eventCategory( $(this) ),
          label    = $( this ).data( 'event-label' );

      dispatchTrackingEvent( category, 'click', label );
    });
  };

  dispatchTrackingEvent = function( category, event, label ) {
    if( typeof ga == 'function' ) { // google analytics
      ga( 'send', 'event', category, event, label );
    }
    if( typeof _paq == 'object' ) { // piwik
      _paq.push( ['trackPageView', category+'/'+label] )
    }
  }

  eventCategory = function( $el ) {
    var cat = 'undefined';
    if( $el.hasClass( 'button' ) || $el.get(0).tagName == 'button' ) {
      cat = 'button';
    }
    return cat;
  }

  // public

  return {
    init: init
  };

}());
