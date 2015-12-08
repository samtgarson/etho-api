angular
  .module('app')
  .controller('ProcessController', [
    '$scope',
    '$http',
    '$state',
    '$stateParams',
    'Endpoint',
    'User',
    'Token',
    processCtrl]);

function processCtrl ($scope, $http, $state, $stateParams, Endpoint, User, Token) {
  var code = $stateParams.code,
    redirectUri = location.protocol + '//' + location.host + '/process';
  if (!code) $state.go('home');
  $http
    .post(
      Endpoint('auth'),
      {code: code, redirect: redirectUri})
    .then(processAuthRequest)
    .catch(authError);

  function processAuthRequest (response) {
    if (response.status == 201) {
      Token.set(response.data.token);
      User.set(response.data.user);
      $state.go('profile', {user: response.data.user}, {location: 'replace'});
    }
  }

  function authError (response) {
    $state.go('home');
  }
}
