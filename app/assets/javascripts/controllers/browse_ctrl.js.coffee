BrowseCtrl = ($timeout, $state, $scope, videos, YoutubeEmbed, Video, Category) ->
  filtersFromStateParams = ->
    if $state.params['filters']
      JSON.parse(atob($state.params.filters))
    else
      {}

  @videos = videos.videos
  @totalVideos = videos.meta.total_videos
  @categories = {}
  @searchText = ''
  @selectedCategory = filtersFromStateParams()['category']

  $scope.filters = {}
  $scope.$watch 'filters', (newVal, oldVal) ->
    $state.go('dashboard.browse', { filters: btoa(angular.toJson(newVal)) }, {reloadOnSearch: true}) if !_.isEmpty(newVal)
  , true

  @addMoreVideos = =>
    Video.nextPage filtersFromStateParams(), (data) =>
      for video in data.videos
        @videos.push(video)
    , (err) ->
      console.log err

  @filterByCategory = (category) ->
    $scope.filters['category'] = category

  categoryColors = [
    'rgb(127, 0, 0)'
    'rgb(204, 0, 0)'
    'rgb(255, 68, 68)'
    'rgb(255, 127, 127)'
    'rgb(255, 178, 178)'
    'rgb(153, 81, 0)'
    'rgb(204, 108, 0)'
    'rgb(255, 136, 0)'
    'rgb(255, 187, 51)'
    'rgb(255, 229, 100)'
    'rgb(44, 76, 0)'
    'rgb(67, 101, 0)'
    'rgb(102, 153, 0)'
    'rgb(153, 204, 0)'
    'rgb(210, 254, 76)'
    'rgb(60, 20, 81)'
    'rgb(107, 35, 142)'
    'rgb(153, 51, 204)'
    'rgb(170, 102, 204)'
    'rgb(188, 147, 209)'
    'rgb(0, 76, 102)'
    'rgb(0, 114, 153)'
    'rgb(0, 153, 204)'
    'rgb(51, 181, 229)'
    'rgb(142, 213, 240)'
    'rgb(102, 0, 51)'
    'rgb(178, 0, 88)'
    'rgb(229, 0, 114)'
    'rgb(255, 50, 152)'
    'rgb(255, 127, 191)'
    'rgb(10, 10, 10)'
    'rgb(128, 128, 128)'
    'rgb(255, 255, 255)'
  ]

  Category.query (categories) =>
    for category, index in categories
      @categories[category] = categoryColors[index]

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
