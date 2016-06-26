require './help.jade'

Template.help.onRendered ->
  # Delay start of video by a second so as to not suprise user
  Meteor.setTimeout =>
    @$('video').get(0).play()
  , 1000
