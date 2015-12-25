angular
  .module('app')
  .directive('moduleType', ['$compile', 'controllerService', function($compile, controllerService){
    return {
      terminal: true,
      priority: 100000,
      scope: {
        type: '=moduleType',
        index: '=',
        title: '='
      },
      restrict: 'A',
      link: function(scope, elem, attrs, controller) {
        var ctrl = 'module.' + scope.type;
        if (!controllerService.exists(ctrl)) ctrl = 'module.base';

        elem.attr('ng-controller', ctrl + ' as vm');
        elem.attr('ng-class', '{"ready": vm.data}');
        elem.attr('class', underscore(scope.type));
        elem.removeAttr('module-type');

        $compile(elem)(scope);
      }
    };

  }])
  .directive('module', [function(){
    return {
      restrict: 'E',
      templateUrl: moduleTemplate
    };

    function moduleTemplate (el, attr) {
      return 'modules/' + underscore(attr.class);
    }
  }]);

function underscore (s) {
  return s.replace('.', '_');
}
