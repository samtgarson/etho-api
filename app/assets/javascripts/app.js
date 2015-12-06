angular
  .module('app', [
    'ui.router',
    'ng-rails-csrf',
    'states'
  ])
  .controller('appController', ['$scope', '$filter', function($scope, $filter) {
    $scope.title = "Etho";
    $scope.$on('$stateChangeSuccess', function(e, toState) {
        $scope.title = toState.name?$filter('titlecase')(toState.name) + ' | Etho':'Etho';
    });
  }]);
