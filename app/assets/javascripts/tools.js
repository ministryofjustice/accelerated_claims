/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj */

moj.Modules.tools = (function() {
  "use strict";

  var //functions
      removeFromArray
      ;

  removeFromArray = function( arr, item ) {
    var i;

    for( i = arr.length; i--; ) {
      if( arr[ i ] === item ) {
        arr.splice( i, 1 );
      }
    }

    return arr;
  };

  // public

  return {
    removeFromArray: removeFromArray
  };

}());
