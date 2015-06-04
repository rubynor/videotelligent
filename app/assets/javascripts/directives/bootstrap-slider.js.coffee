BootstrapSlider = ->
  restrict: 'A'
  scope:
    bootstrapSlider: '='
    valueChanged: '='
  link: (scope, element) ->
    element
      .slider(scope.bootstrapSlider)
      .on 'slide', (slide) ->
        scope.valueChanged(slide.value)

angular
  .module('Videotelligent')
  .directive('bootstrapSlider', [BootstrapSlider])
