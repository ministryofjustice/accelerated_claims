/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj */

moj.Modules.tools = (function() {
  "use strict";

  var //functions
      removeFromArray,
      numToWords,
      ucFirst,
      getRadioVal
      ;

  removeFromArray = function( arr, item ) {
    var i;

    for( i = arr.length; i >= 0; i-- ) {
      if( arr[ i ] === item ) {
        arr.splice( i, 1 );
      }
    }

    return arr;
  };

  numToWords = function( s ) {
    // Convert numbers to words
    // copyright 25th July 2006, by Stephen Chapman http://javascript.about.com
    // permission to use this Javascript on your web page is granted
    // provided that all of the code (including this copyright notice) is
    // used exactly as shown (you can change the numbering system if you wish)

    var th = ['','thousand','million', 'billion','trillion'],
        dg = ['zero','one','two','three','four', 'five','six','seven','eight','nine'],
        tn = ['ten','eleven','twelve','thirteen', 'fourteen','fifteen','sixteen', 'seventeen','eighteen','nineteen'],
        tw = ['twenty','thirty','forty','fifty', 'sixty','seventy','eighty','ninety'],
        x,
        n,
        str,
        sk,
        y,
        i;
    

    s = s.toString();
    s = s.replace(/[\, ]/g,'');
    if (s != parseFloat(s)) {
      return 'not a number';
    }
    x = s.indexOf('.');
    if (x == -1) {
      x = s.length;
    }
    if (x > 15) {
      return 'too big';
    }
    n = s.split('');
    str = '';
    sk = 0;
    for (i=0; i < x; i++) {
      if ((x-i)%3==2) {
        if (n[i] == '1') {
          str += tn[Number(n[i+1])] + ' ';
          i++;
          sk=1;
        } else if (n[i]!=0) {
          str += tw[n[i]-2] + ' ';
          sk=1;
        }
      } else if (n[i]!=0) {
        str += dg[n[i]] +' ';
        if ((x-i)%3==0) {
          str += 'hundred ';
        }
        sk=1;
      } if ((x-i)%3==1) {
        if (sk) {
          str += th[(x-i-1)/3] + ' ';
        }
        sk=0;
      }
    }
    if (x != s.length) {
      y = s.length;
      str += 'point ';
      for (i=x+1; i<y; i++) {
        str += dg[n[i]] +' ';
      }
    }
    return str.replace(/\s+/g,' ');
    
  };

  ucFirst = function( str ) {
    var f;

    str += '';
    f = str.charAt( 0 ).toUpperCase();
    return f + str.substr( 1 );
  };

  getRadioVal = function ( $el ) {
    var radioVal = 'unchecked',
        x;

    for( x = 0; x < $el.length; x++ ) {
      if( $( $el[ x ] ).is( ':checked' ) ) {
        radioVal = $( $el[ x ] ).val();
      }
    }

    return radioVal;
  };

  // public

  return {
    removeFromArray: removeFromArray,
    numToWords: numToWords,
    ucFirst: ucFirst,
    getRadioVal: getRadioVal
  };

}());
