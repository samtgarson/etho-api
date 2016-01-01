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
    redirectUri = location.protocol + '//' + location.host + '/process',
    authHash = {
      url: Endpoint('auth'),
      data: {code: code, redirect: redirectUri},
      method: 'POST',
      skipAuthorization: true
    };

  makeAuthRequestOrReturn()
    .then(processAuthRequest)
    .catch(processAuthError);

  function makeAuthRequestOrReturn () {
    if (!code) $state.go('home');
    return $http(authHash);
  }

  function processAuthRequest (response) {
    if (response.status == 201) {
      Token.set(response.data.token);
      User.set(response.data.user);
      $state.go('profile', {user: response.data.user}, {location: 'replace'});
    }
  }

  function processAuthError (response) {
    $state.go('home');
  }
}
