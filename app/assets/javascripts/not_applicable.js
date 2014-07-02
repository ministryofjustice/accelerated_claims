/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.notApplicable = (function() {
  "use strict";

  var //functions
      init,
      cacheEls,
      hideRadios,

      //elements
      $naRadios
      ;

  init = function() {
    cacheEls();

    hideRadios();
  };

  cacheEls = function() {
    $naRadios = $( '[value=""]' );
  };

  hideRadios = function() {
    var $this;
    $naRadios.each( function() {
      $this = $( this );
      $this.add( $this.parent( 'label' ) ).hide();
    } );
  };

  // public

  return {
    init: init
  };

}());
