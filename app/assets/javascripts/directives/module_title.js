angular
  .module('app')
  .directive('moduleTitle', [function(){
    return {
      templateUrl: 'shared/module_title',
    };
  }]);
