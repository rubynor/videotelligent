BrowseCtrl = ($timeout, $state, $scope, videos, YoutubeEmbed, Video, Category) ->

  params = if $state.params.filters then JSON.parse(atob($state.params.filters)) else {}
  params.order_by = videos.meta.order_by

  Category.get (categories) =>
    @categories = categories

  $scope.videos = videos.videos
  $scope.totalVideos = videos.meta.total_videos
  $scope.searchText = ''

  $scope.$watch 'searchText', (newVal, oldVal) ->
    return unless newVal != oldVal
    params.query = newVal
    reload_data()

  reload_data = ->
    Video.firstPage params, (data) =>
      $scope.videos = data.videos
      $scope.totalVideos = data.meta.total_videos

  refresh_state = ->
    $state.go('dashboard.browse', { filters: btoa(angular.toJson(params)) }, { reloadOnSearch: true })

  @orderBy = (type) ->
    params.order_by = type
    refresh_state()

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
    refresh_state()

  @goToVideo = (id) ->
    $state.go('dashboard.video', { id: id })

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['$timeout', '$state', '$scope', 'videos', 'YoutubeEmbed', 'Video', 'Category', BrowseCtrl])
