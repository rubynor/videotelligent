BrowseCtrl = ($timeout, $state, $scope, videos, YoutubeEmbed, Video, Category) ->

  params = if $state.params then angular.copy($state.params) else {}
  params.order_by = videos.meta.order_by
  params.category = '' unless params.category

  Category.get (categories) =>
    @categories = categories

  $scope.videos = videos.videos
  $scope.totalVideos = videos.meta.total_videos
  $scope.searchText = params.query

  $scope.$watch 'searchText', (newVal, oldVal) ->
    return unless newVal != oldVal
    params.query = newVal
    reloadData()

  reloadData = ->
    console.log("reloading data")
    Video.firstPage params, (data) =>
      $scope.videos = data.videos
      $scope.totalVideos = data.meta.total_videos
    refreshState()

  refreshState = ->
    console.log("refreshing state")
    console.log("order by: " + params.order_by)
    console.log("category: " + params.category)
    console.log("params" + JSON.stringify(params))

    $state.go('dashboard.browse', { order_by: params.order_by, category: params.category }, { reloadOnSearch: true })

  @orderBy = (type) ->
    params.order_by = type
    refreshState()

  @isOrderedBy = (type) ->
    params.order_by == type

  @isActiveCategory = (category) ->
    params.category == category

  @addMoreVideos = =>
    Video.nextPage params, (data) =>
      $scope.videos = $scope.videos.concat data.videos
    , (err) ->
      console.log err

  @filterByCategory = (category) ->
    params.category = category
    refreshState()

  @goToVideo = (id) ->
    $state.go('dashboard.video', { id: id })

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['$timeout', '$state', '$scope', 'videos', 'YoutubeEmbed', 'Video', 'Category', BrowseCtrl])
