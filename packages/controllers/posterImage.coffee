if Meteor.isClient

  Template.posterImage.helpers
    mediaIsVideo: ->
      @mediaType.get() in [2,'2']
