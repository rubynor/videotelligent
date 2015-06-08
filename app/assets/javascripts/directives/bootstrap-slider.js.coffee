BootstrapSlider = ->
  restrict: 'A'
  scope:
    bootstrapSlider: '='
    min: '='
    max: '='
    valueChanged: '='
  link: (scope, element) ->
    scope.slider = element.slider(scope.bootstrapSlider)
    scope.slider.on 'slide', (slide) ->
      scope.valueChanged(slide.value)

    updateMinMax = ->
      return

    scope.$watch('min', (newVal, oldVal) ->
      #scope.slider('setValue', newVal.value)
    )



angular
  .module('Videotelligent')
  .directive('bootstrapSlider', [BootstrapSlider])
