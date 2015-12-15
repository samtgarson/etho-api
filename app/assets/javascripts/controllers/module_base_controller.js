var moduleBaseController = new Class({
  initialize: function ($scope, $http, Endpoint, User) {
    this.$http = $http;
    this.endpoint = Endpoint;
    this.type = $scope.$parent.type;
    this.opts = $scope.$parent.opts;
    this.user = User;

    this.getData();
  },
  getData: function () {
    var vm = this;
    this.$http.get(this.apiUrl()).then(function (response) {
      vm.data = response.data;
    });
  },
  apiUrl: function () {
    return this.endpoint(['users', 'me', this.typeAsUrl()]);
  },
  typeAsUrl: function () {
    return this.type.split('.').join('/');
  }
});

angular.module('app')
  .controller('module.base', ['$scope', '$http', 'Endpoint', 'User', moduleBaseController]);
