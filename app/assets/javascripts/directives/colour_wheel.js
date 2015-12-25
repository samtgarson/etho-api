angular
  .module('app')
  .directive('colourWheel', [function(){
    return {
      scope: {
        rawColours: '=colours'
      },
      restrict: 'E',
      templateUrl: 'shared/colour_wheel',
      link: function($scope, iElm, iAttrs, controller) {
        var max = $scope.rawColours.reduce(findMax, 0);
        $scope.colours = $scope.rawColours.map(createStyle);

        function findMax (max, current) {
          return current.count > max? current.count : max;
        }

        function createStyle (hash) {
          return {
            'height': (hash.count / max * 65) + 40 + 'px',
            'background-color': '#' + hash.colour
          };
        }
      }
    };
  }]);
