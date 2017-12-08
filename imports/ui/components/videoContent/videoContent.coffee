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

  showControls: ->
    Template.instance().stop.mediaType is 2

Template.videoContent.events
  'ended video': (event) ->
    event.target.webkitExitFullScreen()

  'webkitendfullscreen video': (event, instance) ->
    lockOrientation('portrait')

  'playing video': (event, instance) ->
    console.log instance.stop.mediaType
    if instance.stop.mediaType is 2
      lockOrientation('landscape')

  'click video': (event, instance) ->
    console.log '$$$$$$$$$$$'
    event.currentTarget.play()
