angular
  .module('app')
  .controller('ProfileController', ['$scope', 'User', function ($scope, User) {
    $scope.user = User;
    $scope.modules = [
      {
        type: 'me',
        title: 'Profile'
      },
      {
        type: 'stats.colours'
      }
    ];
  }]);
