MainCtrl = ->
  @test = 'Hello world'

angular
  .module "Videotelligent"
  .controller 'MainCtrl', [MainCtrl]
