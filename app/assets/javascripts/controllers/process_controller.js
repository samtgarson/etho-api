angular
  .module('app')
  .controller('ProcessController', [
    '$scope',
    '$http',
    '$state',
    '$stateParams',
    'Endpoint',
    function ($scope, $http, $state, $stateParams, Endpoint) {
    var code = $stateParams.code,
      redirectUri = location.protocol + '//' + location.host + '/process';
    if (!code) $state.go('home');
    $http.post(Endpoint('auth'), {code: code, redirect: redirectUri}).then(processAuthRequest);

    function processAuthRequest (response) {
      console.log(response.data.user);
    }
  }]);
