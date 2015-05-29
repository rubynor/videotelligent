SidebarItemHeader = ->
  restrict: 'E'
  template: JST['directives/sidebar_item/sidebar_item_header_directive_template']
  replace: true
  transclude: true
  scope:
    name:       '@'
    icon:       '@'
    labelClass: '@'
    labelText:  '=?'
  link: (scope, element) ->
    scope.isSidebarItemHeader = true
    scope.active = false
    return

SidebarItem = ($state) ->
  restrict: 'E'
  template: JST['directives/sidebar_item/sidebar_item_directive_template']
  replace: true
  scope:
    name:       '@'
    icon:       '@'
    uiSrefName: '@'
    labelClass: '@'
    labelText:  '=?'
    bold: '=?'
  link: (scope, element) ->
    scope.isCurrentState = ->
      result = scope.uiSrefName == $state.current.name
      # Hack to make sure menu is expanded if sub-item is active state
      if scope.$parent.$parent && scope.$parent.$parent.isSidebarItemHeader
        scope.$parent.$parent.active = true if result
      result

    scope.go = ->
      $state.go(scope.uiSrefName)

    console.log scope
    return

angular
  .module('Videotelligent')
  .directive('sidebarItemHeader', [SidebarItemHeader])
  .directive('sidebarItem', ['$state', SidebarItem])
