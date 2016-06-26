{Template} = require 'meteor/templating'

require './posterImage.jade'

Template.posterImage.helpers
  mediaIsVideo: ->
    @mediaType.get() in [2,'2']
