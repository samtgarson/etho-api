angular.module('states', [])
  .config([
    '$stateProvider', '$urlRouterProvider', '$locationProvider',
    function($stateProvider, $urlRouterProvider, $locationProvider) {

      $stateProvider
              .state('home', {
                  url: '/',
                  templateUrl: 'client/home',
                  controller: 'HomeController'
              });

          // default fall back route
          $urlRouterProvider.otherwise('/');

          // enable HTML5 Mode for SEO
          $locationProvider.html5Mode(true);
  }]);
