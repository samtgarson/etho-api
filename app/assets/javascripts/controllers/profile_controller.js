angular
  .module('app')
  .controller('ProfileController', ['$scope', 'User', function ($scope, User) {
    $scope.user = User;
  }]);
