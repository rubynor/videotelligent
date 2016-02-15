McnLogin = ($window, $http) ->
  restrict: 'A'
  link: (scope, element) ->
    scopes = [
      'profile'
      'email'
      'https://www.googleapis.com/auth/youtube.readonly'
      'https://www.googleapis.com/auth/yt-analytics.readonly'
      'https://www.googleapis.com/auth/youtubepartner-content-owner-readonly'
      'https://www.googleapis.com/auth/youtubepartner'
      'https://www.googleapis.com/auth/plus.login'
    ]

    gapi.load 'auth2', ->
      scope.auth2 = gapi.auth2.init(
        client_id: '663769004258-qq4kbh4jrisi4ucuuhfd7aeafekfhnp1.apps.googleusercontent.com'
        scope: scopes.join(' ')
      )

    element.bind 'click', (e) ->
      e.preventDefault()

      scope.auth2.grantOfflineAccess(
        redirect_uri: 'postmessage'
        state: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      ).then (authResult) ->
        if authResult['code']
          $http(
            method: 'POST'
            url: "/users/auth/google_oauth2/callback"
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            data: authResult
            transformRequest: (obj) -> # We need to send the data as url params
              str = []                 # this code handles this.
              for k,v of obj
                str.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
              return str.join("&")
          ).then (data) ->
              $window.location.reload()
        else
          console.log "There was an error."

angular
  .module('Videotelligent')
  .directive('mcnLogin', ['$window', '$http', McnLogin])
