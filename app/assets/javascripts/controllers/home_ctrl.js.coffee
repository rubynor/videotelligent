HomeCtrl = ($sce, $timeout) ->

  backgrounds = [
    'bg-warning'
    'bg-info'
    'bg-primary'
    'bg-success'
    'bg-dark'
    'bg-black'
    'bg-danger'
  ]

  background = ->
    backgrounds[Math.floor(Math.random() * backgrounds.length)]

  videos = [
    'bS5P_LAqiVg'
    'ZTidn2dBYbY'
    'yKORsrlN-2k'
    'NU7W7qe2R0A'
    'h-_hBOHU4dw'
    'cG9P8DLuh0U'
    'qUgFscMmR3c'
    'TWsxfTObuTU'
    'Z1PCtIaM_GQ'
    'bS5P_LAqiVg'
    'ZTidn2dBYbY'
    'yKORsrlN-2k'
    'NU7W7qe2R0A'
    'h-_hBOHU4dw'
    'cG9P8DLuh0U'
    'qUgFscMmR3c'
    'TWsxfTObuTU'
    'Z1PCtIaM_GQ'
  ]

  videosWithBackground = ->
    withBackground = []
    for video in videos
      withBackground.push [ video, background() ]
    withBackground

  @videos = videosWithBackground()

  @getVideoEmbed = (video) ->
    $sce.trustAsHtml('<iframe src="https://www.youtube.com/embed/' + video + '?controls=1&showinfo=0" frameborder="0" allowfullscreen></iframe>')

  return

angular
  .module('Videotelligent')
  .controller('HomeCtrl', ['$sce', '$timeout', HomeCtrl])
