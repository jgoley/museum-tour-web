if Meteor.isClient

  Template.help.onRendered ->
    $('video').get(0).play()
