SidebarCtrl = ($state) ->
  @isCurrentTab = (targetName) ->
    $state.current.name == targetName

  return

angular
  .module('Videotelligent')
  .controller('SidebarCtrl', ['$state', SidebarCtrl])
