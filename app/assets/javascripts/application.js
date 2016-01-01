//= require angular/angular
//= require angular-ui-router
//= require angular-cookies
//= require angular-jwt
//= require moment
//= require ng-rails-csrf
//= require angular-animate
//= require class.js/src/class
//= require jquery
//= require velocity
//= require jquery.event.swipe
//= require unslider
//= require ngFitText
//= require_self
//= require_tree .

var elasticEase = [350, 28];
var bounceEase = [];

angular
  .module('app', [
    'ui.router',
    'ng-rails-csrf',
    'ngCookies',
    'angular-jwt',
    'ngAnimate',
    'ngFitText'
  ])
  .controller('AppController', ['$scope', '$filter', 'User', function($scope, $filter, User) {
    $scope.title = "Etho";
    $scope.$on('$stateChangeSuccess', function(e, toState) {
        $scope.title = toState.name?$filter('titlecase')(toState.name) + ' | Etho':'Etho';
    });

    $scope.$on('$stateChangeError', function (e, to, toParams, from, fromParams, error) {
      console.error(error);
    });

    $scope.showMenu = false;
    $scope.user = false;

    $scope.$watch(function ($scope) {
      return User.loggedIn();
    }, function (newUser) {
      $scope.user = newUser;
    });
  }]);
