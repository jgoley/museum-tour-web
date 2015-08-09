Template.posterImage.helpers
  mediaIsVideo: ->
    console.log 'isvideo',@
    @mediaType.get() in [2,'2']
