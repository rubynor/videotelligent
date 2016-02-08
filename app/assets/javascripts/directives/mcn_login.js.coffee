McnLogin = ($http) ->
  restrict: 'A'
  link: (scope, element) ->
    console.log(gapi)
    #gapi.load 'auth2', ->
    #  scope.auth2 = gapi.auth2.init(
    #    client_id: '980982753309-mq6pcc1dln4oj000l29oj28d284i44r4.apps.googleusercontent.com'
    #    scope: 'profile email https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/yt-analytics.readonly https://www.googleapis.com/auth/youtubepartner-content-owner-readonly https://www.googleapis.com/auth/youtubepartner https://www.googleapis.com/auth/plus.login'
    #  )
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
      
      #scope.auth2.grantOfflineAccess(
      #  redirect_uri: 'postmessage'
      #  state: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      #).then (authResult) ->
      #  if authResult['code']
      #    # Hide the sign-in button now that the user is authorized, for example:
      #    console.log authResult
      #    $http
      #      method: 'POST'
      #      url: "/users/auth/google_oauth2/callback"
      #      headers: {'Content-Type': 'application/x-www-form-urlencoded'}
      #      data: authResult
      #      transformRequest: (obj) ->
      #        str = []
      #        for k,v of obj
      #          str.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
      #        return str.join("&")
      #      success: (data) ->
      #        console.log "Success"
      #  else
      #    console.log "There was an error."

      gapi.auth.authorize(
        immediate: false
        response_type: 'code'
        cookie_policy: 'single_host_origin'
        client_id: '980982753309-mq6pcc1dln4oj000l29oj28d284i44r4.apps.googleusercontent.com'
        scope: 'profile email https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/yt-analytics.readonly https://www.googleapis.com/auth/youtubepartner-content-owner-readonly https://www.googleapis.com/auth/youtubepartner https://www.googleapis.com/auth/plus.login'
        redirect_uri: 'postmessage'
        state: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      , (response) ->
        if (response && !response.error)
          response['g-oauth-window'] = undefined
          console.log(response)
          $http
            method: 'POST'
            url: "/users/auth/google_oauth2/callback"
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            data: response
            transformRequest: (obj) ->
              str = []
              for k,v of obj
                str.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
              return str.join("&")
            success: (data) ->
              console.log "Success"
        else
          console.log 'failed'
      )

angular
  .module('Videotelligent')
  .directive('mcnLogin', ['$http', McnLogin])
