Category = ($resource) ->
  $resource("/categories/:id.json", {id: "@id"}, {query: {isArray: false}})

angular
  .module('Videotelligent')
  .factory('Category', ['$resource', Category])
