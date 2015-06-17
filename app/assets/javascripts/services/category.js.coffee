Category = ($resource) ->
  resource = $resource("/categories/:id.json", {id: "@id"})

  categories = {}

  get: (success) ->
    if  _.isEmpty(categories)
      resource.get (data) ->
        categories = data
        success(categories) if success
    else
      success(categories) if success
    categories

angular
  .module('Videotelligent')
  .factory('Category', ['$resource', Category])
