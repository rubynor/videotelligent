BrowseCtrl = ($timeout, $state, $scope, videos, YoutubeEmbed, Video) ->
  @videos = videos.videos
  @totalVideos = videos.meta.total_videos
  @searchText = ''
  @selectedColor = ''

  @addMoreVideos = =>
    Video.nextPage (data) =>
      for video in data.videos
        @videos.push(video)
    , (err) ->
      console.log err

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
