BrowseCtrl = ($timeout, $state, $scope, videos, YoutubeEmbed, Video, Category) ->

  params = if $state.params.filters then JSON.parse(atob($state.params.filters)) else {}
  params.orderby = videos.meta.orderby
  params.orderDirection = videos.meta.orderDirection

  Category.get (categories) =>
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
    reload()

  isOrderedBy = (type) ->
    params.orderby == type

  toggleOrder = ->
    params.orderDirection = if params.orderDirection == 'desc' then 'asc' else 'desc'

  reload = ->
    Video.firstPage params, (data) =>
      $scope.videos = data.videos
      $scope.totalVideos = data.meta.total_videos

  @orderBy = (type) ->
    params.orderby = type
    toggleOrder()
    reload()

  @orderClass = (type, order) ->
    return '' unless isOrderedBy(type)
    if params.orderDirection == order then 'active' else 'hidden'

  @addMoreVideos = =>
    Video.nextPage params, (data) =>
      $scope.videos = $scope.videos.concat data.videos
    , (err) ->
      console.log err

  @filterByCategory = (category) ->
    $scope.filters.category = category

  @colorByCategoryName = (category_name) =>
    return unless @categories
    @categories[category_name]

  @getVideoEmbed = (uid) ->
    YoutubeEmbed.embed(uid)

  @goToVideo = (id) ->
    $state.go('dashboard.video', { id: id })

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['$timeout', '$state', '$scope', 'videos', 'YoutubeEmbed', 'Video', 'Category', BrowseCtrl])
