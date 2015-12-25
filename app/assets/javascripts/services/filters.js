angular
  .module('app')
  .filter('titlecase', function() {
    return function(s) {
      s = ( s === undefined || s === null ) ? '' : s;
      return s.toString().toLowerCase().replace( /\b([a-z])/g, function(ch) {
         return ch.toUpperCase();
      });
    };
  })
  .filter('withIndex', function () {
    return function(h, i) {
      if (!h) return i;
      return angular.extend(h, {
        index: i
      });
    };
  })
  .filter('zeroPad', function () {
    return function(s, n) {
      if (s.length >= n) return s;
      var zeros = "0".repeat(n);
      return (zeros + s).slice(-1 * n);
    };
  });
