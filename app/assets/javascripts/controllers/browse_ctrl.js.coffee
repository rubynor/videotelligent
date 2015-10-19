BrowseCtrl = ($timeout, $state, $scope, $location, $filter, videos, YoutubeEmbed, Video, Category, Country, countries) ->

  params = if $state.params then angular.copy($state.params) else {}
  params.order_by = videos.meta.order_by
  params.category = '' unless params.category
  params.view_as = 'tile' unless params.view_as
  params.country = '' unless params.country
  params.gender = '' unless params.gender

  $scope.country =  {}
  $scope.gender =  {}

  Category.get (categories) =>
    @categories = categories

  @countries = countries.countries
  $scope.country.selected = $filter('filter')(@countries, {code: params.country})[0] if params.country

  @genders = [ 'male', 'female' ]
  $scope.gender.selected = params.gender if params.gender

  $scope.videos = videos.videos
  $scope.totalVideos = videos.meta.total_videos
  $scope.searchText = params.query
  $scope.viewType = params.view_as

  $scope.$watch 'searchText', (newVal, oldVal) ->
    return unless newVal != oldVal
    params.query = newVal
    reloadData()

  reloadData = ->
    console.log("reloading data")
    Video.firstPage params, (data) =>
      $scope.videos = data.videos
      $scope.totalVideos = data.meta.total_videos
    refreshState(false)

  refreshState = (notify=true) ->
    $state.go('dashboard.browse', params, notify: notify)

  @orderBy = (type) ->
    params.order_by = type
    refreshState()

  @isOrderedBy = (type) ->
    params.order_by == type

  @viewAs = (viewType) ->
    $scope.viewType = viewType
    params.view_as = viewType
    $location.search('view_as', viewType)

  @isViewedAs = (viewType) ->
    $scope.viewType == viewType

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

  @filterByCountry = (country) ->
    params.country = country
    refreshState()

  @filterByGender = (gender) ->
    params.gender = gender
    refreshState()

  @goToVideo = (id) ->
    $state.go('dashboard.video', { id: id })

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['$timeout', '$state', '$scope', '$location', '$filter', 'videos', 'YoutubeEmbed', 'Video', 'Category', 'Country', 'countries', BrowseCtrl])
