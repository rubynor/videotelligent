User = ($http) ->
  me: (success, error) ->
    $http(
      method: 'GET'
      url: '/users/me.json'
    ).then success, error

  logout: (success, error) ->
    $http(
      method: 'DELETE'
      url: '/users/sign_out.json'
    ).then success, error

  update: (userId, data, success, error) ->
    $http(
      method: 'PATCH'
      url: '/users/' + userId
      data: data
    ).then success, error

angular
  .module('Videotelligent')
  .factory('User', ['$http', User])
