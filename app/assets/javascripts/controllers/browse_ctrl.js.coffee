BrowseCtrl = ($timeout, $state, $scope, videos, YoutubeEmbed, Video) ->
  @videos = videos
  @searchText = ''
  @selectedColor = ''

  @minViews = @videos[@videos.length - 1].views
  @maxViews = @videos[0].views
  @filteredMinViews = @minViews
  @filteredMaxViews = @maxViews

  @sliderOptions =
    min: @minViews
    max: @maxViews
    value: [@minViews, @maxViews]
    step: Math.floor(@maxViews / 20)
    orientation: 'horizontal'
    selection: 'after'
    tooltip: 'show'

  @sliderValueChanged = (value) =>
    @filteredMinViews = value[0]
    @filteredMaxViews = value[1]
    $scope.$apply()

  categories =
    'action': '#b71c1c'
    'comedy': '#4a148c'
    'romance': '#880e4f'
    'sci-fi': '#1a237e'
    'drama': '#0d47a1'
    'talkshow': '#006064'
    'music': '#004d40'
    'dancing': '#1b5e20'
    'diy': '#f57f17'
    'fashion': '#e65100'

  background = ->
    categories[Object.keys(categories)[Math.floor(Math.random() * Object.keys(categories).length)]]

  videosWithBackground = ->
    withBackground = []
    for video in videos
      withBackground.push [ video, background() ]
    withBackground

  @categories = ->
    categories

  @getVideoEmbed = (uid) ->
    YoutubeEmbed.embed(uid)

  @goToVideo = (id) ->
    $state.go('dashboard.video', { id: id })

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['$timeout', '$state', '$scope', 'videos', 'YoutubeEmbed', 'Video', BrowseCtrl])
