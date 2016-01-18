BrowseCtrl = ($timeout, $state, $scope, $rootScope, $location, $filter, videos, YoutubeEmbed, Video, Category, Country, countries) ->

  $rootScope.spinner = false

  params = if $state.params then angular.copy($state.params) else {}
  params.order_by = videos.meta.order_by
  params.category = '' unless params.category
  params.view_as = 'tile' unless params.view_as
  params.country = '' unless params.country
  params.gender = '' unless params.gender
  params.age_group = '' unless params.age_group

  $scope.country =  {}
  $scope.gender =  {}
  $scope.age_group =  {}

  Category.get (categories) =>
    @categories = categories

  @countries = countries.countries
  $scope.country.selected = $filter('filter')(@countries, {code: params.country})[0] if params.country

  @genders = [ 'male', 'female' ]
  $scope.gender.selected = params.gender if params.gender

  @age_groups = ["13-17", "18-24", "25-34", "35-44", "45-54", "55-64", "65-"]
  $scope.age_group.selected = params.age_group if params.age_group

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
    $rootScope.spinner = true
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
    # Quickfix to stop app from using method
    # when state is something else..
    # dashboard.browse is hidden in the dom for
    # other states, making this method actually run
    # when scrolling down in other views..
    return unless $state.$current.name == 'dashboard.browse'
    $rootScope.spinner = true
    Video.nextPage params, (data) =>
      $scope.videos = $scope.videos.concat data.videos
      $rootScope.spinner = false
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

  @filterByAgeGroup = (age_group) ->
    params.age_group = age_group
    refreshState()

  @goToVideo = (id) ->
    $state.go('dashboard.video', { id: id })

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['$timeout', '$state', '$scope','$rootScope', '$location', '$filter', 'videos', 'YoutubeEmbed', 'Video', 'Category', 'Country', 'countries', BrowseCtrl])
