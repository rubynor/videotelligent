HomeCtrl = ($sce, $timeout) ->
  @selectedColor = ''

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

  @categories = ->
    categories

  @getVideoEmbed = (video) ->
    $sce.trustAsHtml('<iframe src="https://www.youtube.com/embed/' + video + '?controls=1&showinfo=0" frameborder="0" allowfullscreen></iframe>')

  return

angular
  .module('Videotelligent')
  .controller('HomeCtrl', ['$sce', '$timeout', HomeCtrl])
