Router = ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider.otherwise "/dashboard/home"

  $stateProvider
    .state "dashboard",
      url: "/dashboard"
      views:
        "header": { template: JST['blocks/header'] }
        "sidebar": { template: JST['blocks/sidebar'] }
        "content": { template: JST['blocks/content'] }
        "footer": { template: JST['blocks/footer'] }
    .state "dashboard.home",
      url: "/home"
      template: JST['home']

  $locationProvider.html5Mode(true)

angular
  .module("Videotelligent")
  .config ["$stateProvider", "$urlRouterProvider", "$locationProvider", Router]
