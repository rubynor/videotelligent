BootstrapSlider = ->
  restrict: 'A'
  link: (scope, element) ->
    element.slider()

angular
  .module('Videotelligent')
  .directive('bootstrapSlider', [BootstrapSlider])
