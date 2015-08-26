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
  'ui.utils'
  'oc.lazyLoad'
  'ngMaterial'
  'infinite-scroll'
  'truncate'
]


angular.module('Videotelligent').controller('TypeaheadDemoCtrl', ->
  # Dummy
)

angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 500)