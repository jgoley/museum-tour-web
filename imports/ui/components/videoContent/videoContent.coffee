import './videoContent.jade'
import { ReactiveVar } from 'meteor/reactive-var'

lockOrientation = (orientation) ->
  if Meteor.isCordova
    screen.orientation.lock(orientation)

Template.videoContent.onCreated ->
  @stop = @data.stop

Template.videoContent.helpers
  autoplay: ->
    Template.instance().stop.type is 'single'

  posterImage: ->
    stop = Template.instance().stop
    url = Meteor.settings.public.awsUrl
    if stop.posterImage and stop.mediaType in ['2', 2]
      "http:#{url}/#{stop.tour}/#{stop.posterImage}"
    else if stop.mediaType
      "http:#{url}/#{stop.audioType()}-poster.png"

  audioType: ->
    Template.instance().data.stop.audioType

Template.videoContent.events
  'ended video': (event) ->
    event.target.webkitExitFullScreen()
  'webkitendfullscreen video': ->
    lockOrientation('portrait')
  'playing video': ->
    lockOrientation('landscape')
