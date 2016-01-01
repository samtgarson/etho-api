angular
  .module('app')
  .directive('moduleSlider', ['$timeout', function($timeout){
    return {
      restrict: 'E',
      link: function($scope, el, attrs, controller) {
        $(el).children('.slide').wrapAll('<ul>');
        setupUnslider();

        function setupUnslider() {
          $(el).unslider({
            speed: 625,
            easing: [350, 28],
            activeClass: 'active',
            selectors: {
              container: 'ul:first',
              slides: 'li.slide'
            }
          });
        }
      }
    };
  }]);
