VideoCtrl = ($state, video, YoutubeEmbed) ->
  @current = video.video

  @goToCategory = (category) ->
    $state.go('dashboard.browse', { category: category })

  @richDescription = ->
    # Replace linebrake \n with tag <br/>
    @current.description.replace(/\n/g, '<br/>')

  @embed = =>
    YoutubeEmbed.embed(@current.uid)

  return

angular
  .module('Videotelligent')
  .controller('VideoCtrl', ['$state', 'video', 'YoutubeEmbed', VideoCtrl])
