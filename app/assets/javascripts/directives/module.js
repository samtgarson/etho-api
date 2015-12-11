angular.module('app')
  .directive('controller', ['$compile', 'controllerService', function($compile, controllerService){
    return {
      terminal: true,
      priority: 100000,
      scope: {
        controller: '='
      },
      restrict: 'A',
      link: function(scope, elem, attrs, controller) {
        var ctrl = 'module.' + scope.controller;
        if (!controllerService.exists(ctrl)) ctrl = 'module.base';
        elem.attr('ng-controller', ctrl);
        elem.attr('klass', scope.controller);
        elem.removeAttr('controller');
        $compile(elem)(scope);
      }
    };
  }])
.directive('module', [function(){
  return {
    restrict: 'E',
    templateUrl: moduleTemplate,
    link: function($scope, iElm, iAttrs, controller) {

    }
  };

  function moduleTemplate (el, attr) {
    return 'modules/' + attr.klass;
  }
}]);
