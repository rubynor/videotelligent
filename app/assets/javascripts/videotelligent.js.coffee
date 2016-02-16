angular.module "Videotelligent", [
  'ngAnimate'
  'ngAria'
  'ngResource'
  'ngSanitize'
  'ui.router'
  'ui.select'
  'infinite-scroll'
  'truncate'
  'angularSpinner'
  'ui.bootstrap'
]

angular.module('Videotelligent').run(['$rootScope', ($rootScope) ->
  $rootScope.spinner = true
])

angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 500)
