Video = ($resource) ->
  $resource("/videos/:id.json", {id: "@id"}, {update: {method: "PUT"}})

angular
  .module('Videotelligent')
  .factory('Video', ['$resource', Video])
