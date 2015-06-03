SparklineCharts = ->
  restrict: 'A'
  scope:
    options: '='
    values: '='
  link: (scope, element) ->
    element.sparkline(scope.values, scope.options)

angular
  .module('Videotelligent')
  .directive('sparklineCharts', [SparklineCharts])
