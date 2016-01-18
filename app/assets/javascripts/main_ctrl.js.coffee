MainCtrl = ($scope) ->
  @test = 'Hello world'
  $scope.spinner = false

angular
  .module "Videotelligent"
  .controller 'MainCtrl', [MainCtrl, '$scope']
