Video = ($resource) ->
  $resource("/videos/:id.json", {id: "@id"}, {update: {method: "PUT"}, query: {isArray: false}})

angular
  .module('Videotelligent')
  .factory('Video', ['$resource', Video])
