angular.module('app')
.config(function Config($httpProvider, jwtInterceptorProvider) {
  jwtInterceptorProvider.tokenGetter = ['Token', function(Token) {
    return Token.get();
  }];

  $httpProvider.interceptors.push('jwtInterceptor');
});
