var moduleMeController = moduleBaseController.extend({
  getData: function () {
    this.data = this.user.get();
  }
});

angular
  .module('app')
  .controller('module.me', ['$scope', '$http', 'Endpoint', 'User', moduleMeController]);
