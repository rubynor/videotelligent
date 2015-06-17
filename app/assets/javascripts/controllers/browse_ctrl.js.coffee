BrowseCtrl = ($timeout, $state, $scope, videos, YoutubeEmbed, Video, Category) ->

  params = if $state.params.filters then JSON.parse(atob($state.params.filters)) else {}

  Category.query (categories) =>
    @categories = categories

  @selectedCategory = params.category

  $scope.videos = videos.videos
  $scope.totalVideos = videos.meta.total_videos
  $scope.searchText = ''

  $scope.filters = {}
  $scope.$watch 'filters', (newVal, oldVal) ->
    $state.go('dashboard.browse', { filters: btoa(angular.toJson(newVal)) }, { reloadOnSearch: true }) if !_.isEmpty(newVal)
  , true

  $scope.$watch 'searchText', (newVal, oldVal) ->
    return unless newVal != oldVal
    params.query = newVal
    Video.firstPage params, (data) =>
      $scope.videos = data.videos
      $scope.totalVideos = data.meta.total_videos

  @addMoreVideos = =>
    Video.nextPage params, (data) =>
      $scope.videos = $scope.videos.concat data.videos
    , (err) ->
      console.log err

  @filterByCategory = (category) ->
    $scope.filters.category = category

  @categoriess = ->
    categories

  @getVideoEmbed = (uid) ->
    YoutubeEmbed.embed(uid)

  @goToVideo = (id) ->
    $state.go('dashboard.video', { id: id })

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['$timeout', '$state', '$scope', 'videos', 'YoutubeEmbed', 'Video', 'Category', BrowseCtrl])
