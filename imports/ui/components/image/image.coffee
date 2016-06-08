{Meteor}   = require 'meteor/meteor'
{Template} = require 'meteor/templating'

require './image.jade'

Template.image.events
  'click .delete-tour-image': (e, template) ->
    Meteor.call 'deleteTourImage', template.data
