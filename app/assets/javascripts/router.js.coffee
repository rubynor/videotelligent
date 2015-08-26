Router = ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider.otherwise "/dashboard/browse"

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

    .state "dashboard.browse",
      url: "/browse?order_by&category"
      template: JST['browse']
      controller: 'BrowseCtrl as browse'
      resolve: videos: ['$state', '$stateParams', 'Video', ($state, $stateParams, Video) ->

        console.log("everybody was dashboard browsing, dudududu")
        console.log(JSON.stringify($stateParams))

        params = {
          order_by: $stateParams.order_by,
          category: $stateParams.category
        }

        Video.firstPage(params).$promise
      ]

    .state "dashboard.video",
      url: "/videos/:id"
      template: JST['video']
      controller: 'VideoCtrl as video'
      resolve: video: ['$stateParams', 'Video', ($stateParams, Video) ->
        Video.get($stateParams.id).$promise
      ]

  $locationProvider.html5Mode(true)

angular
  .module("Videotelligent")
  .config ["$stateProvider", "$urlRouterProvider", "$locationProvider", Router]
