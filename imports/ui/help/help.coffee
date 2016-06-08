{Template} = require 'meteor/templating'

require 'help.jade'

Template.help.onRendered ->
  $('video').get(0).play()
