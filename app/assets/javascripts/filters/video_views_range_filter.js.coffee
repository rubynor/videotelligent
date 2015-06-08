VideoViewsRange = ->
  isWithinRange = (video, range) ->
    (video.views > range[0] && video.views < range[1])

  (videos, min, max) ->
    filteredVideos = []
    for video in videos
      filteredVideos.push(video) if isWithinRange(video, [min, max])
    filteredVideos

angular
  .module('Videotelligent')
  .filter('videoViewsRange', [VideoViewsRange])
