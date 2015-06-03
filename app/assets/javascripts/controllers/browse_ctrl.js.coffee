BrowseCtrl = (YoutubeEmbed, $timeout) ->
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

  tags = [
    "funny videos", "funny videos 2015", "funny pranks", "funny vines", "funny cats", "funny videos that make you laugh so hard you cry", "funny fails", "funny cat videos", "funny animals", "funny vines 2015", "funny accident videos", "funny accidents", "funny animal videos", "funny accidents in india", "funny animals compilation", "funny animations for kids", "funny animal vines", "funny auditions", "funny ads", "a funny thing happened on the way to thor's hammer", "a funny thing happened on the way to the forum", "a funny montage", "a funny thing happened on the way to the moon", "a funny kind of love", "a funny thing happened on the way to the forum soundtrack", "a funny kind of love trailer", "a funny song", "a funny thing happened on the way to the forum comedy tonight", "a funny thing happened on the way to thor's hammer full", "funny basketball dunks", "funny baby", "funny boxing", "funny basketball", "funny bloopers", "funny boxing knockouts", "funny baby videos 2015", "funny baby video clips", "funny babies laughing", "funny baby videos 2014", "b funny videos", "block b funny", "mel b funny", "block b funny moments", "mel b funny moments", "jazzy b funny", "team b funny moments", "lil b funny", "jazzy b funny song", "team b funny dance", "funny clips", "funny compilation", "funny commercial", "funny cartoons", "funny cat vines", "funny compilation 2015", "funny cricket moments", "funny cats and dogs", "studio c funny", "studio c funny girlfriend", "the o.c funny moments", "k b c funny", "studio c funny walk", "lunar c funny moments", "a b c funny", "lm.c funny moments", "mel c funny", "funny dogs", "funny dance", "funny dubsmash", "funny dog videos try not to laugh", "funny dog vines", "funny dubsmash videos", "funny dance videos", "funny drunk people", "funny dogs and cats", "funny day", "d funny moments", "pauly d funny moments", "simon d funny", "g.o.d funny", "tenacious d funny", "pauly d funny", "canon in d funny", "initial d funny", "tenacious d funny moments", "g.o.d funny moments", "funny english", "funny epic fails", "funny ellen", "funny english speaking", "funny elevator prank", "funny ellen degeneres moments", "funny english movies", "funny elephants", "funny epic fail compilation 2014", "funny elsa", "e funny videos", "wall-e funny", "andrew e funny movies", "wall-e funny scenes"
  ]

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

  pickRandomTags = ->
    numberOfTags = Math.floor(Math.random() * 15)
    pickedTags = []
    for [0..numberOfTags]
      randomTag = tags[Math.floor(Math.random() * tags.length)]
      pickedTags.push(randomTag) if pickedTags.indexOf(randomTag) == -1
    pickedTags

  videosWithBackground = ->
    withBackground = []
    for video in videos
      withBackground.push [ video, background(), pickRandomTags() ]
    withBackground

  @videos = videosWithBackground()

  @categories = ->
    categories

  @getVideoEmbed = (id) ->
    YoutubeEmbed.embed(id)

  return

angular
  .module('Videotelligent')
  .controller('BrowseCtrl', ['YoutubeEmbed', '$timeout', BrowseCtrl])
