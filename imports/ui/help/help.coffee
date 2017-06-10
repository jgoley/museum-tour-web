import { analytics } from 'meteor/okgrow:analytics'
import './help.jade'

Template.help.onCreated ->
  title = 'Help'
  document.title = title
  analytics.page(title)

Template.help.onRendered ->
  # Delay start of video by a second so as to not suprise user
  Meteor.setTimeout =>
    @$('video').get(0).play()
  , 1000
