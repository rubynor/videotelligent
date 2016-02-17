User = ($http, $rootScope) ->
  @isSignedIn = false

  @me = (success, error) =>
    $http(
      method: 'GET'
      url: '/users/me.json'
    ).then( (response) =>
      @isSignedIn = true
      success(response)
    , error)

  @logout = (success, error) ->
    $http(
      method: 'DELETE'
      url: '/users/sign_out.json'
    ).then success, error

  @update = (userId, data, success, error) ->
    $http(
      method: 'PATCH'
      url: '/users/' + userId
      data: data
    ).then success, error

  return @

angular
  .module('Videotelligent')
  .factory('User', ['$http', '$rootScope', User])
