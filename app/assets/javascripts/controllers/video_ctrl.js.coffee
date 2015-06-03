VideoCtrl = ($state, YoutubeEmbed) ->
  @embed = ->
    YoutubeEmbed.embed($state.params.id)

  return

angular
  .module('Videotelligent')
  .controller('VideoCtrl', ['$state', 'YoutubeEmbed', VideoCtrl])
