Router = ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider.otherwise "/dashboard/home"

  $stateProvider
    .state "dashboard",
      abstract: true
      url: "/dashboard"
      views:
        "header":
          template: JST['blocks/header']
          controller: 'HeaderCtrl as header'
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

    .state "dashboard.browse",
      url: "/browse"
      template: JST['browse']
      controller: 'BrowseCtrl as browse'
      resolve: videos: ['Video', (Video) ->
        Video.query().$promise
      ]

    .state "dashboard.video",
      url: "/videos/:id"
      template: JST['video']
      controller: 'VideoCtrl as video'
      resolve: video: ['$stateParams', 'Video', ($stateParams, Video) ->
        Video.get({id: $stateParams.id}).$promise
      ]

    .state "dashboard.away",
      url: "/away"
      template: JST['away']

  $locationProvider.html5Mode(true)

angular
  .module("Videotelligent")
  .config ["$stateProvider", "$urlRouterProvider", "$locationProvider", Router]
