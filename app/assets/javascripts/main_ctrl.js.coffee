MainCtrl = ($templateCache) ->
  @test = 'Hello world'
  console.log $templateCache.get('templates/app.html')

angular
  .module "Videotelligent"
  .controller 'MainCtrl', ['$templateCache', MainCtrl]
