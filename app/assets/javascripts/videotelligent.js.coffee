angular.module "Videotelligent", [
  'ngAnimate'
  'ngAria'
  'ngCookies'
  'ngMessages'
  'ngResource'
  'ngSanitize'
  'ngTouch'
  'ngStorage'
  'ui.router'
  'ui.bootstrap'
  'ui.select'
  'ui.utils'
  'oc.lazyLoad'
  'ngMaterial'
  'infinite-scroll'
  'truncate'
  'ct.ui.router.extras.sticky'
  'angularSpinner'
]

angular.module('Videotelligent').run(['$rootScope', ($rootScope) ->
  $rootScope.spinner = true
])

angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 500)
