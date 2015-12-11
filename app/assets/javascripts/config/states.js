angular.module('app')
  .config([
    '$stateProvider', '$urlRouterProvider', '$locationProvider',
    function($stateProvider, $urlRouterProvider, $locationProvider) {

      $stateProvider
              .state('home', {
                  url: '/',
                  templateUrl: 'views/home',
                  controller: 'HomeController'
              })
              .state('processing', {
                  url: '/process?code',
                  template: '',
                  controller: 'ProcessController'
              })
              .state('profile', {
                  url: '/profile',
                  templateUrl: 'views/profile',
                  controller: 'ProfileController',
                  controllAs: 'vm',
                  params: {
                    user: null
                  },
                  resolve: {
                    User: function(User, $stateParams) {
                      return $stateParams.user || User.get();
                    }
                  }
              });

          // default fall back route
          $urlRouterProvider.otherwise('/');

          // enable HTML5 Mode for SEO
          $locationProvider.html5Mode(true);
  }]);
