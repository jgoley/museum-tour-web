import './feedback.jade'

Template.feedback.onRendered ->
  setTimeout ->
    console.log $('iframe').contents().find('.survey-title-container').remove()
  , 3000

Template.feedback.helpers

Template.feedback.events
