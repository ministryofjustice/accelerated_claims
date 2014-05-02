/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.eventTracking = (function() {
  "use strict";

  var init,
      dispatchTrackingEvent,
      $tracked_elements
      ;

  init = function() {
    $( '[data-event-label]' ).on( 'click', function() {
      var category = this['href'].replace(/https?:\/\/[^\/]+/i, ""),
          action   = this.text,
          label    = $( this ).data( 'event-label' );

      dispatchTrackingEvent( category, action, label );
    });
  };

  dispatchTrackingEvent = function( category, action, label ) {
    if( typeof ga == 'function' ) {
      ga( 'send', 'event', category, action, label ); // google analytics
    }
  }

  return {
    init: init
  };

}());
