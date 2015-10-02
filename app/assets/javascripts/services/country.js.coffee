Country = ($resource) ->
  resource = $resource("/countries/:id.json", {id: "@id"}, {query: isArray: false})

  countries = {}

  get: (success) ->
    if  _.isEmpty(countries)
      resource.query (data) ->
        countries = data
        success(countries) if success
    else
      success(countries) if success
      countries

angular
  .module('Videotelligent')
  .factory('Country', ['$resource', Country])
