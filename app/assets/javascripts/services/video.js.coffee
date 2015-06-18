Video = ($resource, $filter) ->
  resource = $resource("/videos/:id.json", {id: "@id"}, {update: {method: "PUT"}, query: {isArray: false}})

  nextPage = 1

  firstPage: (params = {}, success) ->
    nextPage = 1
    params['page'] = nextPage
    data = resource.query(params, (data) ->
      nextPage++ unless data.videos.length == 0
      success(data) if success
    )

  nextPage: (params = {}, success, error) ->
    params['page'] = nextPage
    resource.query(params, (data) ->
      nextPage++ unless data.videos.length == 0
      success(data) if success
    , error)

  get: (id) ->
    resource.get({id: id})

  minViews: (videos) ->
    return 0 unless videos.length > 0
    $filter('orderBy')(videos, '+views')[0].views


  maxViews: (videos) ->
    return 0 unless videos.length > 0
    $filter('orderBy')(videos, '-views')[0].views


angular
  .module('Videotelligent')
  .factory('Video', ['$resource', '$filter', Video])
