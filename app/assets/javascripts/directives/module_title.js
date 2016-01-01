angular
  .module('app')
  .directive('moduleTitle', [function(){
    return {
      restrict: 'E',
      templateUrl: 'shared/module_title',
    };
  }]);
