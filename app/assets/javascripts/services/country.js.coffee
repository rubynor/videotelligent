Country = ($resource) ->
  resource = $resource("/countries/:id.json", {id: "@id"})

  countries = {}

  get: (success) ->
    if  _.isEmpty(countries)
      resource.get (data) ->
        countries = data.countries
        success(countries) if success
    else
      success(countries) if success
    countries

angular
  .module('Videotelligent')
  .factory('Country', ['$resource', Country])
