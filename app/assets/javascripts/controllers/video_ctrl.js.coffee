VideoCtrl = ($state, video, YoutubeEmbed) ->
  @current = video.video

  @embed = =>
    YoutubeEmbed.embed(@current.uid)

  return

angular
  .module('Videotelligent')
  .controller('VideoCtrl', ['$state', 'video', 'YoutubeEmbed', VideoCtrl])
