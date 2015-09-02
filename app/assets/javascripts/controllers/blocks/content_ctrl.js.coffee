ContentCtrl = ($state) ->
  @isBrowseState = ->
    $state.includes('dashboard.browse')

  return

angular
  .module("Videotelligent")
  .controller('ContentCtrl', ["$state", ContentCtrl])
