angular.module('app')
  .factory("controllerService", [ "$controller", function($controller) {
    return {
      exists: function(name) {
        try {
          $controller(name, { "$scope": {} }, true);
          return true;
        }
        catch(ex) {
          return false;
        }
      }
    };
  }]);
