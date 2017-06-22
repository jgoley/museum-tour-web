import { Meteor } from 'meteor/meteor'
import { Template } from 'meteor/templating'

import './image.jade'

Template.image.events
  'click .delete-tour-image': (e, template) ->
    Meteor.call 'deleteTourImage', template.data
