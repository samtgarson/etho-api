angular
  .module('app')
  .directive('moduleLoader', [function(){
    return {
      restrict: 'E',
      templateUrl: 'shared/module_loader',
    };
  }]);
