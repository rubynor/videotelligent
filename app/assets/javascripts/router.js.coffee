Router = ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider.otherwise "/"

  $stateProvider
    .state "main",
      url: "/"
      template: JST["main"]

  $locationProvider.html5Mode(true)

angular
  .module("Videotelligent")
  .config ["$stateProvider", "$urlRouterProvider", "$locationProvider", Router]
