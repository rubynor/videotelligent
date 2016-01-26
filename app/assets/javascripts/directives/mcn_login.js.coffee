McnLogin = ($http) ->
  restrict: 'A'
  link: (scope, element) ->
    element.bind 'click', (e) ->
      e.preventDefault()

      #gapi.auth.authorize(
      #  immediate: true
      #  response_type: 'code'
      #  cookie_policy: 'single_host_origin'
      #  client_id: '663769004258-qq4kbh4jrisi4ucuuhfd7aeafekfhnp1.apps.googleusercontent.com'
      #  scope: 'email profile'
      #, (response) ->
      #  return
      #)

      gapi.auth.authorize(
        immediate: false
        response_type: 'code'
        cookie_policy: 'single_host_origin'
        client_id: '663769004258-qq4kbh4jrisi4ucuuhfd7aeafekfhnp1.apps.googleusercontent.com'
        scope: 'profile email https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/yt-analytics.readonly https://www.googleapis.com/auth/youtubepartner-content-owner-readonly https://www.googleapis.com/auth/youtubepartner https://www.googleapis.com/auth/plus.login'
      , (response) ->
        if (response && !response.error)
          response['g-oauth-window'] = undefined
          $http(
            method: 'POST'
            url: "/users/auth/google_oauth2/callback"
            data: response
            success: (data) ->
              console.log "Success"
          )
        else
          console.log 'failed'
      )

angular
  .module('Videotelligent')
  .directive('mcnLogin', ['$http', McnLogin])
