Category = ($resource) ->
  resource = $resource("/categories/:id.json", {id: "@id"}, {query: {isArray: false}})

  categories = {}

  query: (success) ->
    if _.isEmpty(categories)
      resource.query (data) ->
        categories = data.categories
        success(categories)
    else
      success(categories)
      categories

angular
  .module('Videotelligent')
  .factory('Category', ['$resource', Category])
