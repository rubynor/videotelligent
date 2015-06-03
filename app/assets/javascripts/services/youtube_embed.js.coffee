YoutubeEmbed = ($sce) ->
  embed: (id) ->
    $sce.trustAsHtml('<iframe src="https://www.youtube.com/embed/' + id + '?controls=1&showinfo=0" frameborder="0" allowfullscreen></iframe>')

angular
  .module('Videotelligent')
  .factory('YoutubeEmbed', ['$sce', YoutubeEmbed])
