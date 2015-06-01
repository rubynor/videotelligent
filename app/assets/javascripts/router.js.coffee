Router = ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider.otherwise "/dashboard/home"

  $stateProvider
    .state "dashboard",
      abstract: true
      url: "/dashboard"
      views:
        "header":
          template: JST['blocks/header']
        "sidebar":
          template: JST['blocks/sidebar']
          controller: 'SidebarCtrl as sidebar'
        "content":
          template: JST['blocks/content']
        "footer":
          template: JST['blocks/footer']

    .state "dashboard.home",
      url: "/home"
      template: JST['home']
      controller: 'HomeCtrl as home'

    .state "dashboard.away",
      url: "/away"
      template: JST['away']

  $locationProvider.html5Mode(true)

angular
  .module("Videotelligent")
  .config ["$stateProvider", "$urlRouterProvider", "$locationProvider", Router]
