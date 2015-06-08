Video = ($resource, $filter) ->
  resource = $resource("/videos/:id.json", {id: "@id"}, {update: {method: "PUT"}, query: {isArray: false}})

  next_page = 1

  query: (success, error) ->
    resource.query({page: next_page}, (data) ->
      next_page++ unless data.videos.length == 0
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
